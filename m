Return-Path: <linux-kernel-owner+w=401wt.eu-S1764942AbYBUL6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764942AbYBUL6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYBUL6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:58:22 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:40581 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbYBUL6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:58:20 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: Re: [2.6 patch] scsi/qla4xxx/ql4_isr.c: remove dead code
Date: Thu, 21 Feb 2008 12:51:23 +0100
User-Agent: KMail/1.9.9
Cc: "Andrew Vasquez" <andrew.vasquez@qlogic.com>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Adrian Bunk" <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
References: <0BB3E5E7462EEA4295BC02D49691DC0701277989@AVEXCH1.qlogic.org>
In-Reply-To: <0BB3E5E7462EEA4295BC02D49691DC0701277989@AVEXCH1.qlogic.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2537298.1IBjjA3VHb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802211251.34437.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2537298.1IBjjA3VHb
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> The correct patch needs to be
>
> Signed-off-by: David C Somayajulu <david.somayajulu@qlogic.com>
>
> ---
>
> diff --git a/drivers/scsi/qla4xxx/ql4_isr.c
> b/drivers/scsi/qla4xxx/ql4_isr.c
> index 0f029d0..fc84db4 100644
> --- a/drivers/scsi/qla4xxx/ql4_isr.c
> +++ b/drivers/scsi/qla4xxx/ql4_isr.c
> @@ -100,8 +100,7 @@ static void qla4xxx_status_entry(struct
>
>  		if (sts_entry->iscsiFlags &ISCSI_FLAG_RESIDUAL_UNDER) {
>  			scsi_set_resid(cmd, residual);
> -			if (!scsi_status && ((scsi_bufflen(cmd) -
> residual) <
> -				cmd->underflow)) {
> +			if ((scsi_bufflen(cmd) - residual) <
> cmd->underflow) {

The patch is line-wrapped and can' be applied.

Greetings,

Eike

--nextPart2537298.1IBjjA3VHb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHvWXGXKSJPmm5/E4RArLGAKCmtRwDDDnSOeBTtYVIyT4x+/I3rgCgob5p
p2A/YBvALCGRhySCQ67Css0=
=gRJ+
-----END PGP SIGNATURE-----

--nextPart2537298.1IBjjA3VHb--
