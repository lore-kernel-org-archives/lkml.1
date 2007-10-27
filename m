Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbXJ0OmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbXJ0OmB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbXJ0Olx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:41:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56102 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbXJ0Olw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:41:52 -0400
Subject: Re: jffs2_init_acl_post() can return uninitialized variable
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: KaiGai Kohei <kaigai@ak.jp.nec.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <20071027141842.GV30533@stusta.de>
References: <20071027141842.GV30533@stusta.de>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 10:42:01 -0400
Message-Id: <1193496121.2533.44.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-27 at 16:18 +0200, Adrian Bunk wrote:
> Commit cfc8dc6f6f69ede939e09c2af06a01adee577285 added the following 
> function that can return the value of an uninitialized variable:

Thanks.

Linus, please pull the fix from git://git.infradead.org/mtd-2.6.git

David Woodhouse (2):
      [JFFS2] Prevent return of initialised variable in jffs2_init_acl_post()
      [JFFS2] Update MAINTAINERS entry -- the jffs-dev list is dead

 MAINTAINERS    |    4 ++--
 fs/jffs2/acl.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


-- 
dwmw2

