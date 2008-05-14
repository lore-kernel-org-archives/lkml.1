Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbYENO2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbYENO2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbYENO21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:28:27 -0400
Received: from mx1.suse.de ([195.135.220.2]:57853 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbYENO20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:28:26 -0400
From: Andreas Schwab <schwab@suse.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: main.c:(.init.text+0x730): undefined reference to `strlen'
References: <Pine.LNX.4.64.0805140958400.5778@anakin>
	<jeprrpth5m.fsf@sykes.suse.de>
	<20080514141056.GB19909@cs181133002.pp.htv.fi>
X-Yow: Two with FLUFFO, hold th' BEETS..side of SOYETTES!
Date: Wed, 14 May 2008 16:28:24 +0200
In-Reply-To: <20080514141056.GB19909@cs181133002.pp.htv.fi> (Adrian Bunk's
	message of "Wed, 14 May 2008 17:10:56 +0300")
Message-ID: <jeabitt0xj.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> Or replace all the strlen stuff in include/asm-m68k/string.h with a 

I don't think the strlen macros has any influence in this case (it
already uses __builtin_strlen anyway).  I'd rather guess that gcc is
expanding strncat internally to something involving strlen with
non-constant argument, although I cannot see how that can happen from a
quick look.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
