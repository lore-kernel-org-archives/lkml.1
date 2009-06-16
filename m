Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbZFPGqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbZFPGqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbZFPGqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:46:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:35694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbZFPGqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:46:16 -0400
Message-ID: <4A373F63.1050704@kernel.org>
Date: Tue, 16 Jun 2009 15:44:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: unsik Kim <donari75@gmail.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       joerg@dorchain.net, geert@linux-m68k.org, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
Subject: Re: [PATCH] mg_disk: seperate mg_disk.h again
References: <1245131994-21518-1-git-send-email-donari75@gmail.com>
In-Reply-To: <1245131994-21518-1-git-send-email-donari75@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 16 Jun 2009 06:44:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsik Kim wrote:
> eec9462088a26c046d4db3100796a340a50890b8 fold mg_disk.h into mg_disk.c,
> but mg_disk platform driver needs private data for operation. This also
> make mg_disk.c as machine independent. Seperate only needed structure and
> defines to mg_disk.h
> 
> Signed-off-by: unsik Kim <donari75@gmail.com>
...
> diff --git a/include/linux/mg_disk.h b/include/linux/mg_disk.h
> new file mode 100644
> index 0000000..e11f4d9
> --- /dev/null
> +++ b/include/linux/mg_disk.h
> @@ -0,0 +1,45 @@
> +/*
> + *  include/linux/mg_disk.c
                           ^^^ oops
> + *
> + *  Private data for mflash platform driver
> + *
> + * (c) 2008 mGine Co.,LTD
> + * (c) 2008 unsik Kim <donari75@gmail.com>

Thanks.

-- 
tejun
