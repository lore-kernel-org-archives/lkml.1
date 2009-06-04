Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbZFDJNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbZFDJNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZFDJNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:13:05 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:42577 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZFDJNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:13:04 -0400
Date: Thu, 4 Jun 2009 11:15:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [Patch 1/2] kbuild: two trivial fixes for check headers
Message-ID: <20090604091519.GA9571@uranus.ravnborg.org>
References: <20090604080406.7005.27662.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604080406.7005.27662.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 04:01:52AM -0400, Amerigo Wang wrote:
> 
> Remove a useless 'extern' in an exported header.
> Fix a comment headers_check.pl.

These two patches has nothing in commom.

> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> 
> ------
> diff --git a/include/mtd/jffs2-user.h b/include/mtd/jffs2-user.h
> index fa94b0e..10dc7ef 100644
> --- a/include/mtd/jffs2-user.h
> +++ b/include/mtd/jffs2-user.h
> @@ -18,7 +18,7 @@
>  #undef je32_to_cpu
>  #undef jemode_to_cpu
>  
> -extern int target_endian;
> +int target_endian;

You now declare a global variable named target_endian each time you include this file - which is wrong.
