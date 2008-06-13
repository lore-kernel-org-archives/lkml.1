Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbYFMTjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbYFMTjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 15:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbYFMTjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 15:39:11 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:63523 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYFMTjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 15:39:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18514.52439.909824.925873@stoffel.org>
Date: Fri, 13 Jun 2008 15:39:03 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: "John Stoffel" <john@stoffel.org>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: Re: 2.6.26-rc5: CFI: Found no ck804xrom @ffc00000 device at 
 location zero
In-Reply-To: <20080612222523.7ae0e8eb@hyperion.delvare>
References: <20080612182308.GA1091@ldl.fc.hp.com>
	<18513.27708.452410.527696@stoffel.org>
	<20080612222523.7ae0e8eb@hyperion.delvare>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jean" == Jean Delvare <khali@linux-fr.org> writes:

This patch fixed my issue with excessive warnings on loading various
mtd drivers.  

Tested-by: John stoffel <john@stoffel.org>

Jean> Signed-off-by: Jean Delvare <khali@linux-fr.org>
Jean> ---
Jean>  drivers/mtd/chips/gen_probe.c |    4 ++--
Jean>  1 file changed, 2 insertions(+), 2 deletions(-)

Jean> --- linux-2.6.26-rc5.orig/drivers/mtd/chips/gen_probe.c	2008-04-17 04:49:44.000000000 +0200
Jean> +++ linux-2.6.26-rc5/drivers/mtd/chips/gen_probe.c	2008-06-12 22:20:12.000000000 +0200
Jean> @@ -71,8 +71,8 @@ static struct cfi_private *genprobe_iden
Jean>  	   interleave and device type, etc. */
Jean>  	if (!genprobe_new_chip(map, cp, &cfi)) {
Jean>  		/* The probe didn't like it */
Jean> -		printk(KERN_DEBUG "%s: Found no %s device at location zero\n",
Jean> -		       cp->name, map->name);
Jean> +		pr_debug("%s: Found no %s device at location zero\n",
Jean> +			 cp->name, map->name);
Jean>  		return NULL;
Jean>  	}
 


Jean> -- 
Jean> Jean Delvare
