Return-Path: <linux-kernel-owner+w=401wt.eu-S1030346AbXBZRXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030346AbXBZRXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030354AbXBZRXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:23:12 -0500
Received: from smtp01.cdmon.com ([86.109.99.230]:62051 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030346AbXBZRXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:23:11 -0500
Date: Mon, 26 Feb 2007 18:04:41 +0100
From: DervishD <lkml@dervishd.net>
To: James Simmons <jsimmons@infradead.org>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: tdfx framebuffer garbles display in 2.6.19.5
Message-ID: <20070226170441.GA13496@DervishD>
Mail-Followup-To: James Simmons <jsimmons@infradead.org>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	Linux Fbdev development list <linux-fbdev-devel@lists.sourceforge.net>
References: <20070226144744.GA3615@DervishD> <Pine.LNX.4.64.0702261520420.27244@pentafluge.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0702261520420.27244@pentafluge.infradead.org>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi James :)

 * James Simmons <jsimmons@infradead.org> dixit:
> >     From time to time, the tdfxfb driver from 2.6.19.5 (sorry, I cannot
> > test in 2.6.20.x because it doesn't compile, the infamous BDF negative
> > offset problem) garbles the display, leaving only a lot of thin lines,
> > just like sync was lost. The display can be repaired by switching to
> > another console, but this is annoying. This happens with a Voodoo 3
> > 3000, using 800x600x8@100 mode.
> > 
> >     Anyone has this problem? Can it be solved changing anything?
> 
> Does not compile? Can you post the compile error. For my setup it does 
> compile. 

    I think I didn't explain it well: the tdfxfb driver compiles, but
the *kernel* doesn't. At link time the linker warns about a negative
offset being used and building stops. The driver itself builds perfectly
as far as I can tell.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
