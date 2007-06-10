Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbXFJJRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbXFJJRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXFJJRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:17:14 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:44489 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbXFJJRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:17:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=CR5S/B1J43Ivi6UUs2EdrVyAN8Vl6iTAMx+uXVguqQz43O2Y+8/Cq+bH/u9BYFFZBBdxxJc+Ewdi18+AAi9VmwCVBRfu/V5l+s5ws5KBMbvm9GoW4jytQw1vJnfT89aR;
Message-ID: <466BC18F.9090202@simon.arlott.org.uk>
Date: Sun, 10 Jun 2007 10:17:03 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Tarkan Erimer <tarkan@netone.net.tr>
CC: davids@webmaster.com, linux-kernel@vger.kernel.org, neilb@suse.de,
       jengelh@computergmbh.de
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <MDEHLPKNGKAHNMBLJOLKAEFCEHAC.davids@webmaster.com> <466BB85B.6050703@netone.net.tr>
In-Reply-To: <466BB85B.6050703@netone.net.tr>
X-Enigmail-Version: 0.95.1
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/07 09:37, Tarkan Erimer wrote:
> BTW,I found a really interesting blog entry about which code in Linux
> Kernel is using which version of GPL :
> 
> http://6thsenseless.blogspot.com/2007/02/how-much-linux-kernel-code-is-gpl-2.html
> 
> 
> The work done on a Linux 2.6.20. The result is quite interesting.
> Because almost half  (Around %60 of the code licensed under "GPLv2 Only"
> and the rest is "GPLv2 or above","GPL-Version not specified,others that
> have not stated which and what version of License has been used) of the
> code is "GPLv2 or above" licensed. And also stated in the article that
> some of the codes should be "Dual Licensed" not the whole Linux kernel
> needed to be "Dual Licensed". So,if it is really like this, maybe we can
> make,for example: "File system related Codes", "Dual Licensed" and it
> will allow us to port ZFS from OpenSolaris requested by a lot of people
> or other things maybe ?

Once code obtained under the GPLv2 only licence that the kernel is released 
under is modified and submitted back to Linus for inclusion, that code 
would become GPLv2 only - only the original would be BSD/LGPL/GPLv2+ and 
only separate changes to the original could continue to be available under 
dual licence. Since most files will have been modified at various stages 
in Linux's development when major internal changes occur, surely practically 
everything is now GPLv2 only?


> So, does it mean we can change the license of the dead people's code ? 

If you can contact whoever currently owns the copyright, they can release 
it under another licence... however this is no good because the derivative 
work would be GPLv2 only. Perhaps if you got *everyone* at all stages of 
development (including code that has been removed if existing code is a 
derivative work of it) to agree - then it could work.

It only takes one person's code, uncooperative or not contactable, to 
prevent a change to the licence, so there's not much point in trying 
unless you intend to start replacing such code.


On 10/06/07 10:03, Jan Engelhardt wrote:
> You've got to take MODULE_LICENSE() into account. There is
> 
> 	MODULE_LICENSE("GPL");
> 	MODULE_LICENSE("GPL v2");
> 	MODULE_LICENSE("GPL and additional rights");
> 	MODULE_LICENSE("Dual BSD/GPL");
> 	MODULE_LICENSE("Dual MIT/GPL");
> 	MODULE_LICENSE("Dual MPL/GPL");

Surely that doesn't work since the entire Linux kernel is (and can only be) 
released as GPLv2? Wouldn't anyone making changes to those files need to 
obtain a copy under the other licence and explicitly release it under both 
licenses in order to maintain that?

-- 
Simon Arlott
