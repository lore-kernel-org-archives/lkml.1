Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZDMXf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZDMXf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbZDMXey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:34:54 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:39110 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbZDMXew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:34:52 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>, Eric Miao <eric.y.miao@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrey Borzenkov <arvidjaar@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Pavel Roskin <proski@gnu.org>
Subject: Re: [REGRESSION] commit 66c1ca0: {fbmem: fix fb_info->lock and mm->mmap_sem ...} causes Xfbdev not working
References: <f17812d70904090436kd03744brca4a4bc4b85bba8@mail.gmail.com>
	<20090409125850.GA2727@linux>
	<20090410222122.87be60f6.krzysztof.h1@poczta.fm>
	<20090410220521.GB21294@linux>
	<20090411080415.7fe924a2.krzysztof.h1@poczta.fm>
	<49E05C36.9040204@s5r6.in-berlin.de> <20090411110840.GA7108@linux>
	<20090411150359.GA8265@linux>
X-Yow: ..  I think I'll KILL myself by leaping out of this
 14th STORY WINDOW while reading ERICA JONG'S poetry!!
Date: Tue, 14 Apr 2009 01:34:47 +0200
In-Reply-To: <20090411150359.GA8265@linux> (Andrea Righi's message of "Sat, 11
	Apr 2009 17:04:00 +0200")
Message-ID: <m21vrwi0vc.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi <righi.andrea@gmail.com> writes:

> Tested intelfb and X11 with fbdev. It seems to work fine, but I may be
> unable to test the mode switching right now:
>
>   intelfb: Non-CRT device is enabled ( LVDS port ).  Disabling mode switching.
>
> It would be great if someone could help me to test this patch (against
> latest Linus' git - no need to revert 66c1ca).

I can confirm that it fixes the issue.  Tested with radeonfb and MOL.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
