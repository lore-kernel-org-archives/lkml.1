Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbZD2Ewc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbZD2Ewc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 00:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZD2EwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:52:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061AbZD2EwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:52:22 -0400
Date: Tue, 28 Apr 2009 21:49:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "vimal singh" <vimalsingh@ti.com>
Cc: linux-mtd@lists.infradead.org, dedekind@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [resending] [PATCH] [MTD] [NAND] Add OMAP2 / OMAP3 NAND driver
Message-Id: <20090428214946.c2cda766.akpm@linux-foundation.org>
In-Reply-To: <59607.192.168.10.89.1240816226.squirrel@dbdmail.itg.ti.com>
References: <59607.192.168.10.89.1240816226.squirrel@dbdmail.itg.ti.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 12:40:26 +0530 (IST) "vimal singh" <vimalsingh@ti.com> wrote:

> I am sending this patch again, after Fixing Artem's comments. Also CC'ed to lkml.
> 
> --
> Best regards,
> vimal
> 
> 
> This driver is present in the OMAP tree, now pushing it to MTD.
> 
> Original author(s):
> 	Jian Zhang <jzhang@ti.com>

That's not a particularly illuminating changelog.

> +config MTD_NAND_OMAP2
> +	tristate "NAND Flash device on OMAP2 and OMAP3"
> +	depends on ARM && MTD_NAND && (ARCH_OMAP2 || ARCH_OMAP3)
> +	help
> +          Support for NAND flash on Texas Instruments OMAP2 and OMAP3 platforms.

OK, that tells us more.


Please pass this (and all other) patches through scripts/checkpatch.pl.
checkpatch finds problem in this patch which you would have fixed, had
you known about them.

> +#define TF(value)	(value ? 1 : 0)
> +
> +#define P2048e(a)	(TF(a & NAND_Ecc_P2048e)	<< 0)
> +#define P2048o(a)	(TF(a & NAND_Ecc_P2048o)	<< 1)
> +#define P1e(a)		(TF(a & NAND_Ecc_P1e)		<< 2)
> +#define P1o(a)		(TF(a & NAND_Ecc_P1o)		<< 3)
> +#define P2e(a)		(TF(a & NAND_Ecc_P2e)		<< 4)
> +#define P2o(a)		(TF(a & NAND_Ecc_P2o)		<< 5)
> +#define P4e(a)		(TF(a & NAND_Ecc_P4e)		<< 6)
> +#define P4o(a)		(TF(a & NAND_Ecc_P4o)		<< 7)
> +
> +#define P8e(a)		(TF(a & NAND_Ecc_P8e)		<< 0)
> +#define P8o(a)		(TF(a & NAND_Ecc_P8o)		<< 1)
> +#define P16e(a)		(TF(a & NAND_Ecc_P16e)		<< 2)
> +#define P16o(a)		(TF(a & NAND_Ecc_P16o)		<< 3)
> +#define P32e(a)		(TF(a & NAND_Ecc_P32e)		<< 4)
> +#define P32o(a)		(TF(a & NAND_Ecc_P32o)		<< 5)
> +#define P64e(a)		(TF(a & NAND_Ecc_P64e)		<< 6)
> +#define P64o(a)		(TF(a & NAND_Ecc_P64o)		<< 7)
> +
> +#define P128e(a)	(TF(a & NAND_Ecc_P128e)		<< 0)
> +#define P128o(a)	(TF(a & NAND_Ecc_P128o)		<< 1)
> +#define P256e(a)	(TF(a & NAND_Ecc_P256e)		<< 2)
> +#define P256o(a)	(TF(a & NAND_Ecc_P256o)		<< 3)
> +#define P512e(a)	(TF(a & NAND_Ecc_P512e)		<< 4)
> +#define P512o(a)	(TF(a & NAND_Ecc_P512o)		<< 5)
> +#define P1024e(a)	(TF(a & NAND_Ecc_P1024e)	<< 6)
> +#define P1024o(a)	(TF(a & NAND_Ecc_P1024o)	<< 7)
> +
> +#define P8e_s(a)	(TF(a & NAND_Ecc_P8e)		<< 0)
> +#define P8o_s(a)	(TF(a & NAND_Ecc_P8o)		<< 1)
> +#define P16e_s(a)	(TF(a & NAND_Ecc_P16e)		<< 2)
> +#define P16o_s(a)	(TF(a & NAND_Ecc_P16o)		<< 3)
> +#define P1e_s(a)	(TF(a & NAND_Ecc_P1e)		<< 4)
> +#define P1o_s(a)	(TF(a & NAND_Ecc_P1o)		<< 5)
> +#define P2e_s(a)	(TF(a & NAND_Ecc_P2e)		<< 6)
> +#define P2o_s(a)	(TF(a & NAND_Ecc_P2o)		<< 7)
> +
> +#define P4e_s(a)	(TF(a & NAND_Ecc_P4e)		<< 0)
> +#define P4o_s(a)	(TF(a & NAND_Ecc_P4o)		<< 1)

(ick)

I suspect that the above will expand into quite large amounts of poor
code at the sites where they are invoked.

eg:

	ecc_buf[2] = ~(P4o(tmp) | P4e(tmp) | P2o(tmp) | P2e(tmp) | P1o(tmp) |
			P1e(tmp) | P2048o(tmp) | P2048e(tmp));

this might cause the generation of eight test-n-branch operations,
whereas it could have been done with one.

> +/**
> + * omap_nand_wp - This function enable or disable the Write Protect feature on
> + * NAND device

Alas, kerneldoc doesn't support that.  The description ("This function
enable or disable the Write Protect feature on NAND device") must all
be on a single line.

> + * @mtd: MTD device structure
> + * @mode: WP ON/OFF
> + */
> +static void omap_nand_wp(struct mtd_info *mtd, int mode)
> +{
> +	struct omap_nand_info *info = container_of(mtd,
> +						struct omap_nand_info, mtd);
> +
> +	unsigned long config = __raw_readl(info->gpmc_baseaddr + GPMC_CONFIG);
> +
> +	if (mode)
> +		config &= ~(NAND_WP_BIT);	/* WP is ON */
> +	else
> +		config |= (NAND_WP_BIT);	/* WP is OFF */
> +
> +	__raw_writel(config, (info->gpmc_baseaddr + GPMC_CONFIG));
> +}
> +
> +/**
> + * hardware specific access to control-lines
> + * NOTE: boards may use different bits for these!!
> + *
> + * @ctrl:
> + * NAND_NCE: bit 0 - don't care
> + * NAND_CLE: bit 1 -> Command Latch
> + * NAND_ALE: bit 2 -> Address Latch
> + */

This comment purports to be a kerneldoc comment (it starts with /**) ,
but in fact it is not a kerneldoc comment.

Please review the comments in this patch.

> +						GPMC_CS_NAND_DATA;
> +		break;
> +
> +	case NAND_CTRL_CHANGE | NAND_CTRL_ALE:
> +		info->nand.IO_ADDR_W = info->gpmc_cs_baseaddr +
> +						GPMC_CS_NAND_ADDRESS;
> +		info->nand.IO_ADDR_R = info->gpmc_cs_baseaddr +
> +						GPMC_CS_NAND_DATA;
> +		break;
> +
> +	case NAND_CTRL_CHANGE | NAND_NCE:
> +		info->nand.IO_ADDR_W = info->gpmc_cs_baseaddr +
> +						GPMC_CS_NAND_DATA;
> +		info->nand.IO_ADDR_R = info->gpmc_cs_baseaddr +
> +						GPMC_CS_NAND_DATA;
> +		break;
> +	}
> +
> +	if (cmd != NAND_CMD_NONE)
> +		__raw_writeb(cmd, info->nand.IO_ADDR_W);
> +}
> +
>
> ...
>
> +/**
> + * omap_calcuate_ecc - Generate non-inverted ECC bytes.
> + * Using noninverted ECC can be considered ugly since writing a blank
> + * page ie. padding will clear the ECC bytes. This is no problem as long
> + * nobody is trying to write data on the seemingly unused page. Reading
> + * an erased page will produce an ECC mismatch between generated and read
> + * ECC bytes that has to be dealt with separately.
> + * @mtd: MTD device structure
> + * @dat: The pointer to data on which ecc is computed
> + * @ecc_code: The ecc_code buffer
> + */

I believe the description of the function arguments must precede the
general discussion.

> +static int omap_calculate_ecc(struct mtd_info *mtd, const u_char *dat,
> +				u_char *ecc_code)
> +{
> +	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
> +							mtd);
> +	unsigned long val = 0x0;
> +	unsigned long reg;
> +
> +	/* Start Reading from HW ECC1_Result = 0x200 */
> +	reg = (unsigned long)(info->gpmc_baseaddr + GPMC_ECC1_RESULT);
> +	val = __raw_readl(reg);
> +	*ecc_code++ = val;          /* P128e, ..., P1e */
> +	*ecc_code++ = val >> 16;    /* P128o, ..., P1o */
> +	/* P2048o, P1024o, P512o, P256o, P2048e, P1024e, P512e, P256e */
> +	*ecc_code++ = ((val >> 8) & 0x0f) | ((val >> 20) & 0xf0);
> +	reg += 4;
> +
> +	return 0;
> +}
> +
> +/**
> + * omap_enable_hwecc - This function enables the hardware ecc functionality
> + * @mtd: MTD device structure
> + * @mode: Read/Write mode
> + */
> +static void omap_enable_hwecc(struct mtd_info *mtd, int mode)
> +{
> +	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
> +							mtd);
> +	register struct nand_chip *chip = mtd->priv;

gcc has ignored keyword `register' for a decade at least (unless
invoked with -O0).  Please zap.

> +	unsigned int dev_width = (chip->options & NAND_BUSWIDTH_16) ? 1 : 0;
> +	unsigned long val = __raw_readl(info->gpmc_baseaddr + GPMC_ECC_CONFIG);
> +
> +	switch (mode) {
> +	case NAND_ECC_READ    :
> +		__raw_writel(0x101, info->gpmc_baseaddr + GPMC_ECC_CONTROL);
> +		/* (ECC 16 or 8 bit col) | ( CS  )  | ECC Enable */
> +		val = (dev_width << 7) | (info->gpmc_cs << 1) | (0x1);
> +		break;
> +	case NAND_ECC_READSYN :
> +		 __raw_writel(0x100, info->gpmc_baseaddr + GPMC_ECC_CONTROL);
> +		/* (ECC 16 or 8 bit col) | ( CS  )  | ECC Enable */
> +		val = (dev_width << 7) | (info->gpmc_cs << 1) | (0x1);
> +		break;
> +	case NAND_ECC_WRITE   :
> +		__raw_writel(0x101, info->gpmc_baseaddr + GPMC_ECC_CONTROL);
> +		/* (ECC 16 or 8 bit col) | ( CS  )  | ECC Enable */
> +		val = (dev_width << 7) | (info->gpmc_cs << 1) | (0x1);
> +		break;
> +	default:
> +		DEBUG(MTD_DEBUG_LEVEL0, "Error: Unrecognized Mode[%d]!\n",
> +					mode);
> +		break;
> +	}
> +
> +	__raw_writel(val, info->gpmc_baseaddr + GPMC_ECC_CONFIG);
> +}
> +#endif
> +
> +/**
> + * omap_wait - Wait function is called during Program and erase
> + * operations and the way it is called from MTD layer, we should wait
> + * till the NAND chip is ready after the programming/erase operation
> + * has completed.
> + * @mtd: MTD device structure
> + * @chip: NAND Chip structure
> + */
> +static int omap_wait(struct mtd_info *mtd, struct nand_chip *chip)
> +{
> +	register struct nand_chip *this = mtd->priv;
> +	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
> +							mtd);
> +	int status = 0;
> +
> +	this->IO_ADDR_W = (void *) info->gpmc_cs_baseaddr +
> +						GPMC_CS_NAND_COMMAND;
> +	this->IO_ADDR_R = (void *) info->gpmc_cs_baseaddr + GPMC_CS_NAND_DATA;
> +
> +	while (!(status & 0x40)) {
> +		 __raw_writeb(NAND_CMD_STATUS & 0xFF, this->IO_ADDR_W);
> +		status = __raw_readb(this->IO_ADDR_R);
> +	}

This loop looks like it could consume rather a lot of energy.  Can it
be optimised?

> +	return status;
> +}
> +
>
> ...
>

