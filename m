Return-Path: <linux-kernel-owner+w=401wt.eu-S1751284AbXCRFVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbXCRFVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 01:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbXCRFVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 01:21:00 -0400
Received: from mtaout5.012.net.il ([84.95.2.13]:13313 "EHLO mtaout5.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbXCRFVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 01:21:00 -0400
Date: Sun, 18 Mar 2007 07:20:57 +0200
From: Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [PATCH 0/15] KVM userspace interface updates
In-reply-to: <20070316083650.GA8525@osiris.boeblingen.de.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: kvm-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Message-id: <45FCCC39.7090104@qumranet.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Sun,
 18 Mar 2007 07:20:58 +0200 (IST)
References: <11736212072915-git-send-email-avi@qumranet.com>
 <20070316083650.GA8525@osiris.boeblingen.de.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Sun, Mar 11, 2007 at 03:53:12PM +0200, Avi Kivity wrote:
>   
>> This patchset updates the kvm userspace interface to what I hope will
>> be the long-term stable interface.  Provisions are included for extending
>> the interface later.  The patches address performance and cleanliness
>> concerns.
>>     
>
> Searching the mailing list I figured that as soons as the interface seems
> to be stable, kvm should/would switch to a system call based interface.
> I assume the userspace interface might still change a lot, especially if
> kvm is ported to new architectures.
> But the general question is: do you still plan to switch to a syscall
> interface?
>   

I don't have any present plans for that.  Maybe when the interface 
starts to evolve at a slower pace, or if it is shown to be significantly 
faster.

Not that interface stabilization here doesn't mean a freeze; it means 
that backwards compatibility starts when this gets merged.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

