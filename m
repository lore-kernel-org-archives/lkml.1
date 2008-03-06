Return-Path: <linux-kernel-owner+w=401wt.eu-S934704AbYCFUgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934704AbYCFUgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758826AbYCFUgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:36:03 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41518 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbYCFUgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:36:00 -0500
Date: Thu, 6 Mar 2008 12:35:58 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] SCSI_AIC94XX must depend on SCSI
Message-ID: <20080306203558.GA7430@tree.beaverton.ibm.com>
References: <200803062009.20309.toralf.foerster@gmx.de> <20080306202246.GB5259@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080306202246.GB5259@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 10:22:46PM +0200, Adrian Bunk wrote:
> This patch fixes the following build error reported by Toralf Förster:
> 
> <--  snip  -->
> 
> ...
>   MODPOST 243 modules
> ERROR: "sas_bios_param" [drivers/scsi/mvsas.ko] undefined!

<snip>

> --- a/drivers/scsi/aic94xx/Kconfig
> +++ b/drivers/scsi/aic94xx/Kconfig

Maybe I'm missing something here, but how does patching aic94xx Kconfig
fix an mvsas build problem?

--D
