Return-Path: <linux-kernel-owner+w=401wt.eu-S938911AbXFHKv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938911AbXFHKv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937387AbXFHKvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:51:13 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53835 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S938695AbXFHKvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:51:11 -0400
Date: Fri, 8 Jun 2007 11:52:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: jcm@jonmasters.org, Jan Engelhardt <jengelh@computergmbh.de>,
       Jesper Juhl <jesper.juhl@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070608115219.694c642d@the-village.bc.nu>
In-Reply-To: <20070608000455.GW5500@stusta.de>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
	<9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
	<Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr>
	<20070607193413.GR5500@stusta.de>
	<20070607232248.332edee8@the-village.bc.nu>
	<20070607232152.GU5500@stusta.de>
	<20070608004117.57868755@the-village.bc.nu>
	<20070608000455.GW5500@stusta.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is that the second byte is interpreted as a control code.
> 
> Is there any trick to get the shell working again in this situation?
> The cursor hangs, and I've not yet found a trick to do anything in this
> xterm again (except for killing it from another xterm).

For gnome terminal just select 'reset terminal' in the menu or escape-[c;
 (from memory) is the VT reset code. If your xterm can be stuck forever
file a security bug against your vendors xterm for a DoS attack problem.

> > "Require" is a rather strong word for a print formatting issue specific
> > to obscure setups.
> 
> See obove, it's not only "print formatting", it's "kills my shell".

It printed a symbol, if your shell really got screwed that much by it
then your shell needs work perhaps. I'm not btw arguing that we shouldn't
teach the tools to be more polite, just that its hardly a "requirement"

Alan
