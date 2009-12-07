Return-Path: <linux-kernel-owner+w=401wt.eu-S934951AbZLGJ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934951AbZLGJ6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 04:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934891AbZLGJ6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 04:58:21 -0500
Received: from www.tglx.de ([62.245.132.106]:46845 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934882AbZLGJ6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 04:58:20 -0500
Date: Mon, 7 Dec 2009 10:53:57 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Emese Revfy <re.emese@gmail.com>
Cc: tony.luck@intel.com, fenghua.yu@intel.com, benh@kernel.crashing.org,
       lethal@linux-sh.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, axboe@kernel.dk, gregkh@suse.de, petero2@telia.com,
       davej@redhat.com, maciej.sosnowski@intel.com, dougthompson@xmission.com,
       airlied@linux.ie, rolandd@cisco.com, sean.hefty@intel.com,
       hal.rosenstock@gmail.com, neilb@suse.de, rdunlap@xenotime.net,
       kyle@mcmartin.ca, deller@gmx.de, jejb@parisc-linux.org,
       jbarnes@virtuousgeek.org, hjk@linutronix.de, david.vrabel@csr.com,
       jeremy@xensource.com, chris.mason@oracle.com, ccaulfie@redhat.com,
       teigland@redhat.com, tytso@mit.edu, adilger@sun.com,
       swhiteho@redhat.com, mfasheh@suse.com, joel.becker@oracle.com,
       rusty@rustcorp.com.au, penberg@cs.helsinki.fi,
       shemminger@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 29/31] Constify struct sysfs_ops for 2.6.32 v1
Message-ID: <20091207095356.GA3243@bluebox.local>
References: <4B198670.2000406@gmail.com> <4B1991E2.5010903@gmail.com> <4B19A33B.9050907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B19A33B.9050907@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 05, 2009 at 01:03:07AM +0100, Emese Revfy wrote:
> From: Emese Revfy <re.emese@gmail.com>
> 
> Constify struct sysfs_ops.
> Per Dave Miller's suggestion, resend with proper CC list and patch format.
> 
> Signed-off-by: Emese Revfy <re.emese@gmail.com>

For the Userspace I/O part:
Acked-by: Hans J. Koch <hjk@linutronix.de>

> ---

[...]

>  drivers/uio/uio.c                     |    4 ++--

[...]

> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index e941367..4de382a 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -129,7 +129,7 @@ static ssize_t map_type_show(struct kobject *kobj, struct attribute *attr,
>  	return entry->show(mem, buf);
>  }
>  
> -static struct sysfs_ops map_sysfs_ops = {
> +static const struct sysfs_ops map_sysfs_ops = {
>  	.show = map_type_show,
>  };
>  
> @@ -217,7 +217,7 @@ static ssize_t portio_type_show(struct kobject *kobj, struct attribute *attr,
>  	return entry->show(port, buf);
>  }
>  
> -static struct sysfs_ops portio_sysfs_ops = {
> +static const struct sysfs_ops portio_sysfs_ops = {
>  	.show = portio_type_show,
>  };
