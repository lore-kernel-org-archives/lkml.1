Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbZHZS6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbZHZS6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbZHZS6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:58:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbZHZS6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:58:30 -0400
Message-ID: <4A9585EC.2030505@redhat.com>
Date: Wed, 26 Aug 2009 21:58:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, gleb@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
References: <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com> <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com> <20090823143021.GA27495@redhat.com> <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com> <20090824214900.GA9899@redhat.com> <alpine.DEB.2.00.0908241508440.7951@makko.or.mcafeemobile.com> <20090825072229.GA10608@redhat.com> <alpine.DEB.2.00.0908251456230.18518@makko.or.mcafeemobile.com> <20090826102908.GA21523@redhat.com> <alpine.DEB.2.00.0908261040100.7780@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0908261040100.7780@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2009 08:45 PM, Davide Libenzi wrote:
> OK, if I get it correctly, there is one eventfd signaler (the device), and
> one eventfd reader (the hypervisor), right?
> Each hypervisor listens for multiple devices detecting state changes, and
> associating the eventfd "line" to the IRQ number by some configuration
> (ala PCI), right?
>    

Yes.  The PCI stuff happens in userspace, all the hypervisor sees is 
"this eventfd is IRQ 10".  There may be multiple eventfds routed to one 
IRQ (corresponding to a shared IRQ line).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

