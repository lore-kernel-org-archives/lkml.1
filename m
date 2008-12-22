Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbYLVXYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbYLVXYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbYLVXY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:24:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755385AbYLVXYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:24:24 -0500
Date: Mon, 22 Dec 2008 15:24:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: schmitz@opal.biophys.uni-duesseldorf.de,
       linux-fbdev-devel@lists.sourceforge.net, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6] [patch 0/6] Atari frame buffer fixes
Message-Id: <20081222152404.dbbe9bbc.akpm@linux-foundation.org>
In-Reply-To: <20081221150059.844577615@mail.of.borg>
References: <20081221150059.844577615@mail.of.borg>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Dec 2008 16:00:59 +0100
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> This patchsets contains several fixes for the Atari frame buffer device, and
> includes a refactoring of the c2p (Chunky-to-Planar) code:
>   [1] fbdev: atafb - Fix line length handling
>   [2] fbdev: atafb - Fix 16 bpp console
>   [3] fbdev: c2p - Cleanups
>   [4] fbdev: c2p - Extract common c2p core to c2p_core.h
>   [5] fbdev: c2p/atafb - Add support for Atari interleaved bitplanes
>   [6] fbdev: c2p - Rename c2p to c2p_planar and correct indentation
> 
> If nobody objects, I'd like to push this to Linus via the m68k tree, as the
> c2p code is used by m68k drivers (atafb and amifb) only.
> 

OK by me.

CONFIG_ATAFB_FALCON looks like a serial ATA thing.


