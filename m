Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYKFPxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYKFPxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYKFPxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:53:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44986 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbYKFPxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:53:40 -0500
Message-ID: <491312AA.6000006@redhat.com>
Date: Thu, 06 Nov 2008 17:52:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, Eduardo Habkost <ehabkost@redhat.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>	<1225915018-6548-16-git-send-email-ehabkost@redhat.com>	<20081106071445.GI15731@elte.hu> <20081106124031.GO5247@blackpad>	<20081106143021.GD13023@elte.hu> <20081106150610.GA1644@elte.hu> <m1mygczwtu.fsf@frodo.ebiederm.org>
In-Reply-To: <m1mygczwtu.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> If there are a number of problems with reboot and reset
> I'm wondering if we should investigate using an
> outb to port 0x92.  With the right bit set you can trigger
> a toggle of the reset line on many motherboards.
>   

Most likely that's what the ACPI reset describes.

-- 
error compiling committee.c: too many arguments to function

