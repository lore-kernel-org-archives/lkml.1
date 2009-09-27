Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbZI0IiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbZI0IiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZI0IiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:38:19 -0400
Received: from [195.41.46.235] ([195.41.46.235]:47407 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbZI0IiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:38:19 -0400
Date: Sun, 27 Sep 2009 10:38:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alek Du <alek.du@intel.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Makefile: Fix size_append issue for bzip2/lzma kernel
Message-ID: <20090927083817.GA10177@merkur.ravnborg.org>
References: <20090819173854.2250758f@dxy.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819173854.2250758f@dxy.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 05:38:54PM +0800, Alek Du wrote:
> From 6d755cbd7a136a4314f6976275aaa6c9d10bf3e4 Mon Sep 17 00:00:00 2001
> From: Alek Du <alek.du@intel.com>
> Date: Wed, 19 Aug 2009 17:18:39 +0800
> Subject: [PATCH] Makefile: Fix size_append issue for bzip2/lzma kernel
> 
> The Makefile.lib will call "echo -ne" to append uncompressed kernel size to
> bzip2/lzma kernel image. The "echo" here depends on the shell that /bin/sh pointing
> to. On Ubuntu system, the /bin/sh is pointing to dash, which does not support
> "echo -e" at all. Use /bin/echo instead of shell echo should always be safe.
> 
> Signed-off-by: Alek Du <alek.du@intel.com>

Applied.
