Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbXFOUVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbXFOUVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbXFOUVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:21:44 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:14488 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbXFOUVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:21:43 -0400
Date: Fri, 15 Jun 2007 22:21:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: coding style
In-Reply-To: <20070615194140.GE8151@cvg>
Message-ID: <Pine.LNX.4.64.0706152210150.32724@fbirervta.pbzchgretzou.qr>
References: <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com>
 <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr>
 <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com>
 <20070615110326.b0762b7a.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr>
 <20070615191804.GC8151@cvg> <4672E6B3.1080205@intel.com>
 <Pine.LNX.4.64.0706152122050.32724@fbirervta.pbzchgretzou.qr>
 <20070615194140.GE8151@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 15 2007 23:41, Cyrill Gorcunov wrote:
>
>Dunno who wrote that part :(. Jan, look:
>
>	Now, some people will claim that having 8-character indentations makes
>	the code move too far to the right, and makes it hard to read on a
>	80-character terminal screen.  The answer to that is that if you need
>	more than 3 levels of indentation, you're screwed anyway, and should fix
>	your program.
>
>your opinion? Is it a bug too? Don't get me wrong I'm just trying to clarify
>coding style.

Linux maintainers will enforce \t "being"[1] 8, and will also enforce
the 80-column limit[2].

(Assuming maintainer != developer)

To [1]: There is actually no substance in how wide a tab is. The developer
may set a tab width of 4, the maintainer may have his tab width set to 12,
and the end user to 6. As far as I interpret CodingStyle, it reads:

	Use \ts for indent, spaces for align, and make sure your code
	fits into 80 columns when the tab width would be 8.
	(You can test that by adjusting your tab width temporarily)

To [2]: There's always code slipping in that disobeys this ;-)



	Jan
-- 
