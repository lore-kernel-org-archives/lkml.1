Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbZBTC1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbZBTC1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbZBTC1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:27:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52539 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbZBTC1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:27:43 -0500
Message-ID: <499E156F.7020101@cn.fujitsu.com>
Date: Fri, 20 Feb 2009 10:29:03 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: linux-fbdev-devel@lists.sourceforge.net
CC: rjw@sisk.pl, linux-kernel@vger.kernel.org, rui.zhang@intel.com,
       brad@neruo.com, Andrew Morton <akpm@linux-foundation.org>
Subject: =?windows-1252?Q?Re=3A_=5BPATCH=5Datyfb=3Aremove__unused_?=
 =?windows-1252?Q?variable_=91pwr=5Fcommand=92?=
References: <49953E90.8030306@cn.fujitsu.com>
In-Reply-To: <49953E90.8030306@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+CC:brad@neruo.com
+CC:Andrew Morton <akpm@linux-foundation.org>

Yang Hongyang wrote:
> remove  unused variable ‘pwr_command’ 
> 
> Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
> 
> ---
>  drivers/video/aty/aty128fb.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
> index e6e299f..2181ce4 100644
> --- a/drivers/video/aty/aty128fb.c
> +++ b/drivers/video/aty/aty128fb.c
> @@ -2365,7 +2365,6 @@ static void fbcon_aty128_bmove(struct display *p, int sy, int sx, int dy, int dx
>  static void aty128_set_suspend(struct aty128fb_par *par, int suspend)
>  {
>  	u32	pmgt;
> -	u16	pwr_command;
>  	struct pci_dev *pdev = par->pdev;
>  
>  	if (!par->pm_reg)


-- 
Regards
Yang Hongyang
