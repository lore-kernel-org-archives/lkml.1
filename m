Return-Path: <linux-kernel-owner+w=401wt.eu-S1765178AbXG0Nce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765178AbXG0Nce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 09:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbXG0NcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 09:32:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:53642 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbXG0NcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 09:32:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=CmRjOZvxNuMDJvCkzOJcNmUIAjaQXBxt1EHnd4q4kmX4SDsHHdontBN7NpHsamEgKMMKnX53FxBoKbdxkgXW5ankWyjZtHesnEV4KfGUDcsQDDMSVicGZOuOxAfqZz09KfxpBsLwkJ/VIOyaY0Gk5FbpUwRn9Q4pF/ZRF0xmx2w=
Date: Fri, 27 Jul 2007 15:28:53 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, chris@zankel.net
Subject: [-mm patch] xtensa console.c: remove duplicate #include
Message-ID: <20070727132853.GA31203@slug>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/
> 
Hi,

This patch removes one of the two linux/console.h included in
arch/xtensa/platform-iss/console.c

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/arch/xtensa/platform-iss/console.c b/arch/xtensa/platform-iss/console.c
index 2f4f20f..854677d 100644
--- a/arch/xtensa/platform-iss/console.c
+++ b/arch/xtensa/platform-iss/console.c
@@ -20,7 +20,6 @@
 #include <linux/param.h>
 #include <linux/serial.h>
 #include <linux/serialP.h>
-#include <linux/console.h>
 
 #include <asm/uaccess.h>
 #include <asm/irq.h>
