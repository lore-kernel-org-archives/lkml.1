Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbYABG2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbYABG2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 01:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbYABG1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 01:27:52 -0500
Received: from po-out-1718.google.com ([72.14.252.158]:62988 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbYABG1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 01:27:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=dkbkEdz0RyFI1ppc0xiKbEDT5J0vqRA+GmmHvvg37O+mIbSAAwOk8q3PzMxmxyG9URkguyWIz29obuPua2AerwBngsoh4pOD/gwlscmTqNtZi+hHlOxPOwlrd0K1BeIGXMKGhks9pRTtQAzHcnUXQlimtUPPR/RdYOZJQS+whMI=
Date: Wed, 2 Jan 2008 14:27:59 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Mikael Starvik <starvik@axis.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, dev-etrax@axis.com,
       Andreas Schwab <schwab@suse.de>
Subject: (Try #3) [Patch 4/8] CRIS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080102062759.GF2493@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking> <20080101072922.GE2496@hacking> <20080101102010.GD28913@uranus.ravnborg.org> <20080101133421.GD2499@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101133421.GD2499@hacking>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Refine it as suggested by Andreas.

-------->

This patch removes TOPDIR from Cris Makefiles.

Cc: Mikael Starvik <starvik@axis.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andreas Schwab <schwab@suse.de>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/arch/cris/arch-v32/boot/compressed/Makefile b/arch/cris/arch-v32/boot/compressed/Makefile
index 9f77eda..609692f 100644
--- a/arch/cris/arch-v32/boot/compressed/Makefile
+++ b/arch/cris/arch-v32/boot/compressed/Makefile
@@ -7,7 +7,7 @@
 target = $(target_compressed_dir)
 src    = $(src_compressed_dir)
 
-CC = gcc-cris -mlinux -march=v32 -I $(TOPDIR)/include
+CC = gcc-cris -mlinux -march=v32 $(LINUXINCLUDE)
 CFLAGS = -O2
 LD = gcc-cris -mlinux -march=v32 -nostdlib
 OBJCOPY = objcopy-cris
