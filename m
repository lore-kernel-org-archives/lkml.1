Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325Ab0CLW4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 17:56:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932205Ab0CLW4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 17:56:54 -0500
Date: Fri, 12 Mar 2010 14:56:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [mtd, nandsim] Fix typo: struct nandsin_geometry
Message-Id: <20100312145631.36585f9b.akpm@linux-foundation.org>
In-Reply-To: <87aaul1d67.fsf@tac.ki.iif.hu>
References: <87aaul1d67.fsf@tac.ki.iif.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Mar 2010 20:08:00 +0100
Ferenc Wagner <wferi@niif.hu> wrote:

> Subject: [PATCH] [mtd, nandsim] Fix typo: struct nandsin_geometry

fyi, the text inside [] is conventionally considered "transient, to be
removed by receiver", so you should have placed the
subsystem-identification text outside the [].

> Actually, this embedded struct (together with nandsim_regs) could as well
> remain nameless...
> 

Sounds like a fine idea.

> ---
>  drivers/mtd/nand/nandsim.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
> index 7281000..803ae12 100644
> --- a/drivers/mtd/nand/nandsim.c
> +++ b/drivers/mtd/nand/nandsim.c
> @@ -312,7 +312,7 @@ struct nandsim {
>  	union ns_mem buf;
>  
>  	/* NAND flash "geometry" */
> -	struct nandsin_geometry {
> +	struct nandsim_geometry {
>  		uint64_t totsz;     /* total flash size, bytes */
>  		uint32_t secsz;     /* flash sector (erase block) size, bytes */
>  		uint pgsz;          /* NAND flash page size, bytes */


this:


From: Ferenc Wagner <wferi@niif.hu>

The name was spelled wrong.  We don't need an identifier on this struct
anyway, so remove it altogether.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nandsim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/nand/nandsim.c~mtd-nandsim-fix-typo-struct-nandsin_geometry drivers/mtd/nand/nandsim.c
--- a/drivers/mtd/nand/nandsim.c~mtd-nandsim-fix-typo-struct-nandsin_geometry
+++ a/drivers/mtd/nand/nandsim.c
@@ -315,7 +315,7 @@ struct nandsim {
 	union ns_mem buf;
 
 	/* NAND flash "geometry" */
-	struct nandsin_geometry {
+	struct {
 		uint64_t totsz;     /* total flash size, bytes */
 		uint32_t secsz;     /* flash sector (erase block) size, bytes */
 		uint pgsz;          /* NAND flash page size, bytes */
_

