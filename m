Return-Path: <linux-kernel-owner+w=401wt.eu-S1764139AbYBGAWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764139AbYBGAWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932494AbYBFX7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:59:21 -0500
Received: from ns2.suse.de ([195.135.220.15]:32995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482AbYBFX7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:59:18 -0500
Date: Wed, 6 Feb 2008 15:53:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Matthew Wilcox <matthew@wil.cx>, maximilian attems <max@stro.at>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 55/73] m68k: Export cachectl.h
Message-ID: <20080206235356.GD13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="m68k-export-cachectl.h.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Matthew Wilcox <matthew@wil.cx>

patch e92042e5c009d84ba741ec4a978a13f260e6ee24 in mainline.

m68k: Export cachectl.h

libffi in GCC 4.2 needs cachectl.h to do its cache flushing.  But we
don't currently export it.  I believe this patch should do the trick.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-m68k/Kbuild |    1 +
 1 file changed, 1 insertion(+)

--- a/include/asm-m68k/Kbuild
+++ b/include/asm-m68k/Kbuild
@@ -1 +1,2 @@
 include include/asm-generic/Kbuild.asm
+header-y += cachectl.h

-- 
