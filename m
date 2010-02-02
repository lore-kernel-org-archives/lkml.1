Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab0BBTrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:47:52 -0500
Received: from avexch1.qlogic.com ([198.70.193.115]:55090 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab0BBTrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:47:48 -0500
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Linux Driver <Linux-Driver@qlogic.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Message-Id: <BBAD2972-BD0C-4EF2-A842-3DC0E0022E77@qlogic.com>
From: Giridhar Malavali <giridhar.malavali@qlogic.com>
To: Roel Kluin <roel.kluin@gmail.com>
In-Reply-To: <4B62B78F.2010404@gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v912)
Subject: Re: [PATCH] qla2xxx: negative error return in qla2x00_change_queue_depth()
Date: Tue, 2 Feb 2010 11:47:47 -0800
References: <4B62B78F.2010404@gmail.com>
X-Mailer: Apple Mail (2.912)
X-OriginalArrivalTime: 02 Feb 2010 19:47:47.0411 (UTC) FILETIME=[9855EA30:01CAA440]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Giridhar Malavali <giridhar.malavali@qlogic.com>

On Jan 29, 2010, at 2:25 AM, Roel Kluin wrote:

> The *change_queue_depth functions usually return a negative error  
> return.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/ 
> qla_os.c
> index 8529eb1..0753877 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1258,7 +1258,7 @@ qla2x00_change_queue_depth(struct scsi_device  
> *sdev, int qdepth, int reason)
> 		qla2x00_adjust_sdev_qdepth_up(sdev, qdepth);
> 		break;
> 	default:
> -		return EOPNOTSUPP;
> +		return -EOPNOTSUPP;
> 	}
>
> 	return sdev->queue_depth;

