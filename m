Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbXLFRFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbXLFRFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 12:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXLFRF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 12:05:27 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52622 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbXLFRF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 12:05:26 -0500
Message-ID: <47582BCF.3070706@linux.vnet.ibm.com>
Date: Thu, 06 Dec 2007 11:05:19 -0600
From: Brian King <brking@linux.vnet.ibm.com>
Reply-To: brking@linux.vnet.ibm.com
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Denis Cheng <crquan@gmail.com>
CC: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/20] drivers/scsi/ipr.c: use LIST_HEAD instead of LIST_HEAD_INIT
References: <1196954490-5516-1-git-send-email-crquan@gmail.com>
In-Reply-To: <1196954490-5516-1-git-send-email-crquan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Brian King <brking@linux.vnet.ibm.com>

Denis Cheng wrote:
> single list_head variable initialized with LIST_HEAD_INIT could almost
> always can be replaced with LIST_HEAD declaration, this shrinks the code
> and looks better.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  drivers/scsi/ipr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index 0841df0..9018ee8 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -84,7 +84,7 @@
>  /*
>   *   Global Data
>   */
> -static struct list_head ipr_ioa_head = LIST_HEAD_INIT(ipr_ioa_head);
> +static LIST_HEAD(ipr_ioa_head);
>  static unsigned int ipr_log_level = IPR_DEFAULT_LOG_LEVEL;
>  static unsigned int ipr_max_speed = 1;
>  static int ipr_testmode = 0;


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
