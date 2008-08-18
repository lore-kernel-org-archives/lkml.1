Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbYHRWpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbYHRWpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYHRWoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:44:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52009 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753199AbYHRWoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:44:54 -0400
Date: Mon, 18 Aug 2008 23:27:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rc2 when cross-building the kernel
Message-ID: <20080818232740.35eab7f6@lxorguk.ukuu.org.uk>
In-Reply-To: <48A9FA05.9000601@lwfinger.net>
References: <48A63D98.3070900@lwfinger.net>
	<20080818193253.GA30856@uranus.ravnborg.org>
	<48A9FA05.9000601@lwfinger.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>    gcc -Wp,-MD,firmware/.ihex2fw.d -Wall -Wstrict-prototypes -O2 
> -fomit-frame-pointer     -o firmware/ihex2fw firmware/ihex2fw.c
> /bin/sh: scripts/basic/fixdep: cannot execute binary file
> make[1]: *** [firmware/ihex2fw] Error 126
> make: *** [_modinst_post] Error 2

Ditto here when building ARCH=i386 on 64bit then NFS doing "make
modules_install". Also breaks if the NFS mount is ro
