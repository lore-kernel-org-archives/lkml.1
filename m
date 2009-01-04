Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbZADTit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbZADTit (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZADTil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:38:41 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:53875 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676AbZADTil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:38:41 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=L3M69vQ-QNcFUwKxq8AA:9 a=o9mH3Qw3Cr6YsENYV0gA:7 a=OR27naRWr_Iug1xTxDRaPqt9XtkA:4 a=uEg51aum-oIA:10 a=qCKwKjZXkboA:10 a=4yRfZMz16A8A:10
Message-ID: <4961103D.9040009@shaw.ca>
Date: Sun, 04 Jan 2009 13:38:37 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: atoth@atoth.sote.hu
CC: linux-kernel@vger.kernel.org
Subject: Re: Grsecurity is about to be discontinued...
References: <213db97b75b3c08d1a7f9af580563b86.squirrel@atoth.sote.hu>
In-Reply-To: <213db97b75b3c08d1a7f9af580563b86.squirrel@atoth.sote.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atoth@atoth.sote.hu wrote:
> In Reply to Linus Torvalds on Grsecurity:
> 
> These days people out there are running closed-source adobe flash plugin
> to browse pages like ebay.com where one can come across some applets
> causing execution attempts daily. It can be detected using improved
> techniques only.
> I don't care about what code will run on many noobs' machine, but I'd like
> to stay secure. So even if it seems insane, it surely makes sense -
> unfortunately.
> I suspect some of the most important improvements are labeled "annoying"
> by Linus. However some other operating system's board chose to include
> parts of such implementations (I won't list them here). It would be good
> to see as many snippets of PaX/Grsec in the mainline as possible. Please
> take this message as a sign, that Gabor Micsko (trey@hup.hu) is not alone
> with his idea.
> 
> Grsecurity proved itself as a viable, valuable solution for combined
> techniques for hardening Linux. I'm using a laptop which has every
> application running regulated by Grsecurity's RBAC system - including
> _all_ GUI apps. Please warn me, when there will be some security policies
> available to convert a targeted SELinux machine into a fully hardened
> SELinux box with GUI.
> 
> I'm not sure, that putting Grsecurity in the mainline would save the
> project. I rather hope, that some companies using the software will give a
> helping hand to the developers. However the Linux community should turn
> its attention to defensive security solutions, IMHO. As it gets more and
> more abundant, there will be more exploits floating around. Some lessons
> can be learned from those "monkeys" on how to think secure.
> 
> A polished full-featured security system can raise Linux above other
> solutions. The better if there are more possibilities to choose between.
> All features of PaX and Grsecurity can be disabled by default: so an
> ordinary user shouldn't worry about being secure.
> 
> Please consider to think about how secure is your on system and what can
> be done to fix it. If some focused persons provide a specialized solution
> it worth to be investigated.

This is all very nice, but messages like this are not going to help 
anything. If those guys want to get code into the mainline kernel then 
the path for that is the same as for anybody else: concrete, 
step-by-step improvements (i.e. patches) that do not duplicate 
functionality that is already present in the kernel, actually belong in 
the kernel as opposed to userspace, and do not create an undue 
maintenance burden. If such patches were submitted they would 
potentially be accepted. Question is why the grsecurity guys haven't 
done this well before now, as opposed to now when they seem to be in 
crisis mode.

Saying to the kernel developers "here, throw this huge blob of code into 
your kernel because otherwise we're taking our ball and going home" is 
not how it works.
