Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbZHXSb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbZHXSb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbZHXSbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:31:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbZHXSbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:31:24 -0400
Message-ID: <4A92DC93.6030406@redhat.com>
Date: Mon, 24 Aug 2009 21:31:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, gleb@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
References: <20090820155655.GA8764@redhat.com> <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com> <4A8D8A28.2050004@redhat.com> <20090820175540.GA9232@redhat.com> <4A8D90BB.2030506@redhat.com> <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com> <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com> <20090823143021.GA27495@redhat.com> <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2009 09:25 PM, Davide Libenzi wrote:
> Indeed, the default eventfd behaviour is like, well, an event. Signaling
> (kernel side) or writing (userspace side), signals the event.
> Waiting (reading) it, will reset the event.
> If you use EFD_SEMAPHORE, you get a semaphore-like behavior.
> Events and sempahores are two widely known and used abstractions.
> The EFD_STATE proposed one, well, no. Not at all.
>    

There are libraries that provide notifications (or fire watches) when 
some value changes.  They're much less frequently used than events or 
semaphores, though.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

