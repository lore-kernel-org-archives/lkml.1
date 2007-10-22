Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbXJVBhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbXJVBhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 21:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbXJVBhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 21:37:32 -0400
Received: from ufisa.uninett.no ([158.38.152.126]:51107 "EHLO ufisa.uninett.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbXJVBhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 21:37:31 -0400
X-Greylist: delayed 1825 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Oct 2007 21:37:31 EDT
Date: Mon, 22 Oct 2007 03:07:19 +0200 (CEST)
From: =?UTF-8?Q?Kolbj=C3=B8rn_Barmen?= <linux-m68k@kolla.no>
X-X-Sender: kolla@firda.kolla.no
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH] m68k: Use cc-cross-prefix (was: Re: [GI:wqT PULL] kbuild
 updates - second round)
In-Reply-To: <Pine.LNX.4.64.0710212028560.6155@anakin>
Message-ID: <alpine.LNX.0.9999.0710220303400.27496@firda.kolla.no>
References: <20071019204415.GA623@uranus.ravnborg.org> <Pine.LNX.4.64.0710211956280.6155@anakin> <20071021182245.GA5840@uranus.ravnborg.org> <Pine.LNX.4.64.0710212028560.6155@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007, Geert Uytterhoeven wrote:

> +ifneq ($(SUB_ARCH),$(ARCH))
> +     ifeq ($(CROSS_COMPILE),)
> +            CROSS_COMPILE := $(call cc-cross-prefix, m68k-linux-gnu- m68k-linux-)

I've not paid much attention to discussion over this (I tend to build
natively, less stress :) ), so pardon my ignorance. Does the above make
any difference for me when I use CROSS_COMPILE=m68k-unknown-linux-gnu-,
or does it just detect m68k-linux-gnu- and m68k-linux-?

-- kolla, that gentoo/m68k lunatic :)
