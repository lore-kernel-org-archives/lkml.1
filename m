Return-Path: <linux-kernel-owner+w=401wt.eu-S1761820AbXGLXH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761820AbXGLXH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbXGLXHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:07:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50634 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755968AbXGLXHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:07:09 -0400
Date: Thu, 12 Jul 2007 16:06:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 0/4] Cell SPE logos
Message-Id: <20070712160621.644d78d2.akpm@linux-foundation.org>
In-Reply-To: <20070710122702.765654000@pademelon.sonytel.be>
References: <20070710122702.765654000@pademelon.sonytel.be>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 14:27:02 +0200
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> The Cell Broadband Engine contains a 64-bit PowerPC core with 2 hardware
> threads (called PPEs) and 8 Synergistic Processing Engines (called SPEs).
> When booting Linux, 2 penguins logos are shown on the graphical console by
> the standard frame buffer console logo code.
> 
> To emphasize the existence of the SPEs (which can be used under Linux), we
> added a second row of (smaller) helper penguin logos, one for each SPE.
> 
> A sample screenshot can be found at
> http://www.kernel.org/pub/linux/kernel/people/geoff/cell/debian-penguin-shot.png
> (or on the ps3linux T-shirts we wore at OLS :-)

Does this mean I'll get penguins on my PS3 now?

> Summaries:
>   [1] fbdev: extract fb_show_logo_line()
>   [2] fbdev: Add fb_append_extra_logo()

This one does give additional code and data to all fbdev users while only
being useful to cell machines.  Should we fix that?

>   [3] fbdev: SPE helper penguin logo
>   [4] Cell: Draw SPE helper penguin logos

I queued #4 up along with the fbdev patches, even though it isn't really an
fbdev patch.

