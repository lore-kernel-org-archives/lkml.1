Return-Path: <linux-kernel-owner+w=401wt.eu-S1751692AbXCKHxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbXCKHxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 03:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbXCKHxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 03:53:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:8841 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbXCKHxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 03:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=R/PsX1Dk05txqm1f986VTTWrz/CxURYKBl0yLNUy8/16bn+VzAReW4Lnl6u1D95J8KBDH2l94OqD+kxm5m9aGfcdqs0N5LizV9WZFiZ37LhWQp3tESPRBuX3MB1GUISZt0tuCWj/KZ73xjn4iFQq3PCAtxD02RaoNEf/H6zredY=
Date: Sun, 11 Mar 2007 10:50:25 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       linux-kernel-list <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
Message-ID: <20070311075025.GB10572@cvg>
References: <7XcsC-2Iz-3@gated-at.bofh.it> <7XcCq-2VQ-15@gated-at.bofh.it> <7Xd5o-3wR-15@gated-at.bofh.it> <7Xd5o-3wR-13@gated-at.bofh.it> <7Xe1t-52k-11@gated-at.bofh.it> <7XeE6-67b-1@gated-at.bofh.it> <7XhiJ-1UJ-15@gated-at.bofh.it> <7Xhsk-26S-9@gated-at.bofh.it> <7Xiy3-3MW-17@gated-at.bofh.it> <E1HQGVL-0000mI-Oi@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HQGVL-0000mI-Oi@be1.lrz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Bodo Eggert - Sun, Mar 11, 2007 at 06:21:59AM +0100]
| Sam Ravnborg <sam@ravnborg.org> wrote:
| > On Sat, Mar 10, 2007 at 10:34:41PM +0100, Jan Engelhardt wrote:
| >> On Mar 10 2007 22:27, Sam Ravnborg wrote:
| >> >On Sat, Mar 10, 2007 at 07:23:41PM +0100, Jan Engelhardt wrote:
| 
| >> >> Whether the 'working config file path' should change when you do
| >> >> 'Save as Alternate' or not, is a menuconfig axiom. Ask Sam Ravnborg
| >> >> if you want it changed :-)
| >> >
| >> >Current behaviour is not logical but on the other hand I do not
| >> >see a big need to make it so.
| >> >It seems that people very seldom uses "save alternate" anyway.
| >> >
| >> >But patches are welcome.
| >> 
| >> ^_^ The patch has already been posted, has not it?
| > No.
| > Either we keep current behaviour
| 
| , which is misleading,
| 
| > or we change to the "normal"
| > behaviour with a "Save as..." as know from all other programs.
| 
| , which is not desirable, as long as there is no "open" and "save" option
| also working as "normal".
| 
| IMO the option should have the "Save a copy" semantics, since that's what the
| name suggests.

Please decribe me how should it work at all. I mean should we work with
a single _active_ file and then "Save a copy" just put a config snapshot
to some file but that will not affect an original file? Should we work
with any config file as text editors do? Just write your point of view
in details and give kernel community time to review...

| -- 
| Top 100 things you don't want the sysadmin to say:
| 51. YEEEHA!!!  What a CRASH!!!
| 
| Fri?, Spammer: WCD1@7eggert.dyndns.org c0DSB5Uh7w@7eggert.dyndns.org
| 


		Cyrill

