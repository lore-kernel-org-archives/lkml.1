Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbZFONtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbZFONtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZFONtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:49:12 -0400
Received: from mga05.intel.com ([192.55.52.89]:55841 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751689AbZFONtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:49:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,222,1243839600"; 
   d="scan'208";a="699456157"
Date: Mon, 15 Jun 2009 15:51:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: eric miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/da903x: initialize PMIC core early
Message-ID: <20090615135117.GC4094@sortiz.org>
References: <4A363841.5090406@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A363841.5090406@compulab.co.il>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Mon, Jun 15, 2009 at 03:02:09PM +0300, Mike Rapoport wrote:
> Samuel,
> It'd be great if this can go to 2.6.31
Sure. Care to explain why this needs to be called earlier ?

Cheers,
Samuel.

> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> ---
>  drivers/mfd/da903x.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
> index 7283d88..e5ffe56 100644
> --- a/drivers/mfd/da903x.c
> +++ b/drivers/mfd/da903x.c
> @@ -561,7 +561,7 @@ static int __init da903x_init(void)
>  {
>  	return i2c_add_driver(&da903x_driver);
>  }
> -module_init(da903x_init);
> +subsys_initcall(da903x_init);
> 
>  static void __exit da903x_exit(void)
>  {
> -- 
> 1.6.0.6
> 
> 
> -- 
> Sincerely yours,
> Mike.
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
