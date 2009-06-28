Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZF1SGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZF1SGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZF1SGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:06:41 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:51191 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbZF1SGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:06:40 -0400
Date: Sun, 28 Jun 2009 20:05:38 +0200
From: Christof Schmitt <christof.schmitt@de.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux390@de.ibm.com,
       Martin Peschke <mp3@de.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH 41/62] drivers/s390/scsi/zfcp_scsi.c: Remove
	unnecessary semicolons
Message-ID: <20090628180533.GA4168@schmichrtp.de.ibm.com>
References: <cover.1246173664.git.joe@perches.com> <2e6b8497e456ba1a86948d1850428a82cf137218.1246173682.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e6b8497e456ba1a86948d1850428a82cf137218.1246173682.git.joe@perches.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 09:26:46AM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/s390/scsi/zfcp_scsi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 967ede7..7db90da 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -101,7 +101,7 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
>  	if (unlikely((status & ZFCP_STATUS_COMMON_ERP_FAILED) ||
>  		     !(status & ZFCP_STATUS_COMMON_RUNNING))) {
>  		zfcp_scsi_command_fail(scpnt, DID_ERROR);
> -		return 0;;
> +		return 0;
>  	}
> 
>  	ret = zfcp_fsf_send_fcp_command_task(unit, scpnt);

Indeed, very trivial.

Acked-by: Christof Schmitt <christof.schmitt@de.ibm.com>
