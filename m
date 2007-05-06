Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbXEFJEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbXEFJEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 05:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933388AbXEFJEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 05:04:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:47104 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933368AbXEFJEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 05:04:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=KHez9ps02BVBL8fWz17Rhg4Dzsug7YG/7JXJJ8RwVdP33cNt9O/Bfc7yqI8yHUkhDrQ8/jy0hHb/napVzH0/IyO1pi9sbnGg+7SEKAvt6e8PPYnlRscBSTYINsHukEwQUYcxXAyfcvI5nJW/ZnHoQsX5F8+P8zh1fLHYv4Jt7bg=
Date: Sun, 6 May 2007 11:03:33 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: [-mm patch] get_unmapped_area: remove now unused ret variable (was Re: 2.6.21-mm1)
Message-ID: <20070506090333.GB29299@slug>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> 

mm/mmap.c:1393: warning: unused variable 'ret'

The get_unmapped_area-doesnt-need-hugetlbfs-hacks-anymore.patch and
get_unmapped_area-handles-map_fixed-in-generic-code.patch rendered the ret
variable useless.

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/mm/mmap.c b/mm/mmap.c
index b0f6eb8..fabf7f4 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1390,7 +1390,6 @@ unsigned long
 get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags)
 {
-	unsigned long ret;
 	unsigned long (*get_area)(struct file *, unsigned long,
 				  unsigned long, unsigned long, unsigned long);
 
