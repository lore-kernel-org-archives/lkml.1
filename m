Return-Path: <linux-kernel-owner+w=401wt.eu-S933372AbXIAXrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbXIAXrr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 19:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbXIAXrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 19:47:40 -0400
Received: from barikada.upol.cz ([158.194.242.200]:46042 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620AbXIAXrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 19:47:39 -0400
To: Rob Landley <rob@landley.net>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: kconfig/kbuild rewite (Re: What's up with CONFIG_BLK_DEV?)
In-Reply-To: <200708260108.28584.rob@landley.net>
References: <200708241517.28475.rob@landley.net> <Pine.LNX.4.64.0708242234250.28540@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0708242234500.28540@fbirervta.pbzchgretzou.qr> <200708260108.28584.rob@landley.net>
Date: Sun, 2 Sep 2007 02:02:37 +0200
Message-Id: <E1IRcvF-0007yi-73@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sun, 26 Aug 2007 01:08:28 -0500
* Organization: Boundaries Unlimited
>
[]
> Also "here's a symbol, show me a menu containing everything else that is 
> either required by or enabled by this symbol..."  That sounds like a more 
> powerful abstraction, since the previous one is "show me everything that 
> depends on CONFIG_BLOCK".
>
> (I wonder if this would be a largeish rewrite of the menuconfig 
> infrastructure?  Hmmm...)

Yess. I'm doing this, actually. Sam, Andrew and Linus have got an email
half a year ago about my intent. Tried to release 2.6.20-j4f, but that
was just a dream. Now i did some training in non-kernel related stuff and
always catch (30k, 14k) LKML backlogs to stay in tune. Some bits i 
get are here ftp://flower.upol.cz/Linux/info-LKML/tools/

So, ideas: UI, organization, efficiency, simplicity, etc. are welcome.

Maybe in one month i'll get something to show (base is 2.6.22).
Imagination plays very well, the thing must be ground shaking, but i'll
see how it will fit reality. Yours one in consideration from very
beginning, don't bother :)

Another problem that i have to solve before any publishing (it's
completely another tree, logic, interface), is the work tracking system,
i was describing in June. This is important, because i sick of current
chaos and manual organizing work in-tree or in regression tracking.
____
