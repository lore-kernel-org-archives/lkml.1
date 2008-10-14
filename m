Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbYJNXWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbYJNXWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 19:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYJNXWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 19:22:06 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:58183 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbYJNXWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 19:22:04 -0400
Date: Wed, 15 Oct 2008 03:23:50 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage release.
Message-ID: <20081014232350.GA27915@2ka.mipt.ru>
References: <20081013172038.GA18762@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081013172038.GA18762@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, Oct 13, 2008 at 09:20:38PM +0400, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> I am pleased to announce new distributed storage (DST) project release.
> This release increases size of the patch by 10% by providing lots of
> comments on how code works. Also cleaned up number of pointed issues:
> kzalloc/kcalloc, style, config deps and so on.

Just in case you will want to apply it to the latest tree and compile,
following patch is needed to properly work with 2.6.27 tree.
2.6.26 (as what it was against) does not need this.

diff --git a/drivers/block/dst/dcore.c b/drivers/block/dst/dcore.c
index d58eb93..039d59b 100644
--- a/drivers/block/dst/dcore.c
+++ b/drivers/block/dst/dcore.c
@@ -24,6 +24,7 @@
 #include <linux/jhash.h>
 #include <linux/idr.h>
 #include <linux/init.h>
+#include <linux/namei.h>
 #include <linux/slab.h>
 #include <linux/socket.h>
 

-- 
	Evgeniy Polyakov
