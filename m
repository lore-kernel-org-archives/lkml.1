Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbXFOUWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbXFOUWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbXFOUVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:21:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39883 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757227AbXFOUVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:21:50 -0400
Date: Fri, 15 Jun 2007 13:21:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Jan Engelhardt <jengelh@computergmbh.de>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
In-Reply-To: <20070615194140.GE8151@cvg>
Message-ID: <alpine.LFD.0.98.0706151319430.14121@woody.linux-foundation.org>
References: <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com>
 <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr>
 <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com>
 <20070615110326.b0762b7a.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr>
 <20070615191804.GC8151@cvg> <4672E6B3.1080205@intel.com>
 <Pine.LNX.4.64.0706152122050.32724@fbirervta.pbzchgretzou.qr>
 <20070615194140.GE8151@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, Cyrill Gorcunov wrote:
> | 
> | 	from CodingStyle:
> | 	Tabs are 8 characters, and thus indentations are also 8
> | 	characters.  There are heretic movements that try to make
> | 	indentations 4 (or even 2!) characters deep, and that is akin
> | 	to trying to define the value of PI to be 3.
> | 
> | Linus (did he wrote that part?) and the heretics both can have their fun 
> | without impacting each other. If we wanted to force the user to have 
> | exactly 8 screen blanks, we should use spaces throughout.

I did indeed write that.

Tabs are 8 characters in the kernel coding style.

And yes, I also wrote the other quote:

> Dunno who wrote that part :(. Jan, look:
> 
> 	Now, some people will claim that having 8-character indentations makes
> 	the code move too far to the right, and makes it hard to read on a
> 	80-character terminal screen.  The answer to that is that if you need
> 	more than 3 levels of indentation, you're screwed anyway, and should fix
> 	your program.

and I think that's in many ways even more important than the 8-character 
tab, because deep indentation is unreadable even if you *can* fit it on a 
single line.

In the kernel, we try to split functions up, and perhaps use inline 
functions etc, and really really avoid deep indentation.

		Linus
