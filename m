Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbZDRS6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbZDRS6x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 14:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759966AbZDRSyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 14:54:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58261 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759960AbZDRSyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 14:54:01 -0400
Date: Sat, 18 Apr 2009 19:52:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>, takata@linux-m32r.org,
       Christoph Hellwig <hch@lst.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: use include/gen for mach-types.h
Message-ID: <20090418185226.GS26366@ZenIV.linux.org.uk>
References: <20090416150707.GA941@lst.de> <20090416164050.GB4850@uranus.ravnborg.org> <swfmyag9fx8.wl%takata.hirokazu@renesas.com> <alpine.LFD.2.00.0904171034140.4042@localhost.localdomain> <20090417221440.GA16791@uranus.ravnborg.org> <20090418101444.GA9768@flint.arm.linux.org.uk> <20090418181714.GA25786@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090418181714.GA25786@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 08:17:14PM +0200, Sam Ravnborg wrote:
> mach-types.h is a generated file.
> As we no longer has a .gitignore file in asm-arm the risk
> that somebody by accident commit mach-types.h is big.
> 
> Avoid this by the introduction of include/gen/ to
> hold this (and soon other) generated files.
> 
> The patch includes two small cleanups to arch/arm/Makefile.
> 1) delete stale comment
> 2) combine two targets in one line and drop unused prerequisite
> 
> The idea to introduce include/gen/ is originally from Al Viro.

Umm...
	a) why CLEAN_FILES and not MRPROPER_FILES?
	b) I'd simply add include/gen to MRPROPER_FILES in the top-level
Makefile.
	c) .gitignore in there ought to be simply *, if we want to create
.gitignore there at all (we don't do that for include/config and the
world doesn't end, after all).
