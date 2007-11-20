Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbXKTKkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbXKTKkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbXKTKkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:40:31 -0500
Received: from renko.ucs.ed.ac.uk ([129.215.13.3]:40033 "EHLO
	renko.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbXKTKka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:40:30 -0500
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 44/59] drivers/scsi: Add missing "space"
Date: Tue, 20 Nov 2007 10:39:44 +0000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Ali Akcaagac <aliakc@web.de>,
       "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
       Jamie Lenehan <lenehan@twibble.org>, Oliver Neukum <oliver@neukum.name>,
       dc395x@twibble.org, linux-scsi@vger.kernel.org
References: <1195523627-15389-1-git-send-email-joe@perches.com> <1195523627-15389-2-git-send-email-joe@perches.com>
In-Reply-To: <1195523627-15389-2-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201039.45321.alistair@devzero.co.uk>
X-Edinburgh-Scanned: at renko.ucs.ed.ac.uk
    with MIMEDefang 2.52, Sophie, Sophos Anti-Virus, Clam AntiVirus
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007 01:53:31 Joe Perches wrote:
> diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
> index 9e64b21..99403a6 100644
> --- a/drivers/scsi/NCR_D700.c
> +++ b/drivers/scsi/NCR_D700.c
> @@ -182,7 +182,7 @@ NCR_D700_probe_one(struct NCR_D700_private *p, int
> siop, int irq,
>
>  	hostdata = kzalloc(sizeof(*hostdata), GFP_KERNEL);
>  	if (!hostdata) {
> -		printk(KERN_ERR "NCR D700: SIOP%d: Failed to allocate host"
> +		printk(KERN_ERR "NCR D700: SIOP%d: Failed to allocate host "
>  		       "data, detatching\n", siop);
>  		return -ENOMEM;
>  	}

If you're going to sneak in unrelated spelling/grammar changes, you might as 
well do it unilaterally.

"detached" please.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
