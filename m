Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbYAAH3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbYAAH3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 02:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYAAH3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 02:29:09 -0500
Received: from po-out-1718.google.com ([72.14.252.152]:54006 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYAAH3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 02:29:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=tDGApJsF/jYEX5VKKOhP1TRCd/QWPJ39Pg6dfIeuHW98nrnMaG4d4F0KZALV9ekkYU7a94Ki2hoNiG9f9G0GxwDla6Eu66fehLZDV+oKNoB5xCUIcqCWy9zzIDTvLlKyU8xLaEY3JwifAfbCUCmW43/aUcXLtiFN3rDUJevBInk=
Date: Tue, 1 Jan 2008 15:29:22 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Mikael Starvik <starvik@axis.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       dev-etrax@axis.com
Subject: [Patch 4/8] CRIS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101072922.GE2496@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101071311.GA2496@hacking>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


TOPDIR is obsolete, use objtree instead.
This patch removes TOPDIR from all Cris Makefiles.

Cc: Mikael Starvik <starvik@axis.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/arch/cris/arch-v32/boot/compressed/Makefile b/arch/cris/arch-v32/boot/compressed/Makefile
index 9f77eda..8586922 100644
--- a/arch/cris/arch-v32/boot/compressed/Makefile
+++ b/arch/cris/arch-v32/boot/compressed/Makefile
@@ -7,7 +7,7 @@
 target = $(target_compressed_dir)
 src    = $(src_compressed_dir)
 
-CC = gcc-cris -mlinux -march=v32 -I $(TOPDIR)/include
+CC = gcc-cris -mlinux -march=v32 -I $(objtree)/include
 CFLAGS = -O2
 LD = gcc-cris -mlinux -march=v32 -nostdlib
 OBJCOPY = objcopy-cris
