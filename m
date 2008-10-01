Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbYJAHil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbYJAHil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYJAHid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:38:33 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:32830 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751384AbYJAHic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:38:32 -0400
Date: Wed, 1 Oct 2008 09:38:17 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20081001073817.GA3098@anita.doom>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita> <48DA0A2C.8010008@kernel.org> <20080924105943.GB2094@anita> <20080925081848.GB2305@anita> <48DEA40D.40709@kernel.org> <20080930081257.GB18961@anita.doom> <48E232FC.1090902@kernel.org> <20080930151622.GC18961@anita.doom> <48E25831.4030505@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E25831.4030505@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2008-10-01 01:47 +0900 schrieb Tejun Heo:
> Please apply the attached patch and see whether the problem goes
> away.

I will take care of this this evening.

> Also, can you test whether hotplug works with the patch applied?

Erm... I never did Hotplug on SATA, should I plug out the Disk out of
the Mainboard Connector to see what happens? I suspect I need another
additional disk the or a live-usb linux with this Kernel...

> Thanks.

Thats no problem, but one question:

Should this 

> diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
> index 14601dc..18f81d2 100644
> +++ b/drivers/ata/sata_nv.c
> @@ -433,6 +433,7 @@ static struct ata_port_operations nv_nf2_ops = {
>  	.inherits		= &nv_common_ops,
>  	.freeze			= nv_nf2_freeze,
>  	.thaw			= nv_nf2_thaw,
> +	.hardreset		= ATA_OP_NULL,
>  };
>  
>  static struct ata_port_operations nv_ck804_ops = {

go onto vanilla 2.6.27_rc7 WITH or withOUT
sata_nv-reinstate-nv_hardreset.patch?


Regards, Konsti


-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
