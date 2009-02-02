Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZBBP6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZBBP6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 10:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZBBP6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 10:58:35 -0500
Received: from styx.suse.cz ([82.119.242.94]:40443 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752453AbZBBP6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 10:58:34 -0500
Date: Mon, 2 Feb 2009 16:58:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Niels de Vos <niels.devos@wincor-nixdorf.com>
cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH (trivial)] MTD: remove EOL from MODULE_DESCRIPTION
In-Reply-To: <4982D1A3.4070706@wincor-nixdorf.com>
Message-ID: <alpine.LNX.1.10.0902021657480.11630@jikos.suse.cz>
References: <4982D1A3.4070706@wincor-nixdorf.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009, Niels de Vos wrote:

> There is no need to have a "\n" on a MODULE_DESCRIPTION, remove it.
> 
> Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
> 
> ---
> diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
> index e4226e0..e51c1ed 100644
> --- a/drivers/mtd/nand/diskonchip.c
> +++ b/drivers/mtd/nand/diskonchip.c
> @@ -1773,4 +1773,4 @@ module_exit(cleanup_nanddoc);
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
> -MODULE_DESCRIPTION("M-Systems DiskOnChip 2000, Millennium and Millennium Plus device driver\n");
> +MODULE_DESCRIPTION("M-Systems DiskOnChip 2000, Millennium and Millennium Plus device driver");

I don't see this in dwmw2's mtd tree, so I have applied it to trivial 
tree.

-- 
Jiri Kosina
SUSE Labs
