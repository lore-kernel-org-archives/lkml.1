Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbYAYKCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbYAYKCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYAYKCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:02:08 -0500
Received: from www.tglx.de ([62.245.132.106]:35348 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbYAYKCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:02:06 -0500
Date: Fri, 25 Jan 2008 11:01:57 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@computergmbh.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 185/196] UIO: constify function pointer tables
Message-ID: <20080125110157.2e6534f8@dilbert.local>
In-Reply-To: <1201246425-5058-106-git-send-email-gregkh@suse.de>
References: <20080125071127.GA4860@kroah.com>
	<1201246425-5058-106-git-send-email-gregkh@suse.de>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 24 Jan 2008 23:33:34 -0800
schrieb Greg Kroah-Hartman <gregkh@suse.de>:

> From: Jan Engelhardt <jengelh@computergmbh.de>
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> ---
>  drivers/uio/uio.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 03b66fb..cc246fa 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -39,7 +39,7 @@ struct uio_device {
>  
>  static int uio_major;
>  static DEFINE_IDR(uio_idr);
> -static struct file_operations uio_fops;
> +static const struct file_operations uio_fops;
>  
>  /* UIO class infrastructure */
>  static struct uio_class {
> @@ -508,7 +508,7 @@ static int uio_mmap(struct file *filep, struct
> vm_area_struct *vma) }
>  }
>  
> -static struct file_operations uio_fops = {
> +static const struct file_operations uio_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= uio_open,
>  	.release	= uio_release,
