Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbXJ0QxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbXJ0QxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbXJ0QxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:53:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:47997 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbXJ0QxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=luhElRKS88f/k4sDgyfz/hIaRWvfN2QNgNpsPsY5HBTe920gj34UoC9whGwzpOXvVIDSsWmHmGXxFP9EeSnOLP0U01RTF5xvGAaun3rkzS7hwtZSqXdESj6dX0T43e5kvKU8GewxrWAEp8BDWpTAkh0DaiUHShMTn7KX9lGn7Nk=
Date: Sat, 27 Oct 2007 20:53:02 +0400
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix 'and' typos in drivers/block/pktcdvd.c
Message-ID: <20071027165302.GA9816@martell.zuzino.mipt.ru>
References: <47235033.7060908@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47235033.7060908@tiscali.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 04:50:27PM +0200, Roel Kluin wrote:
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -2202,11 +2202,11 @@ static int pkt_media_speed(struct pktcdvd_device *pd, unsigned *speed)
>  		return ret;
>  	}
>  
> -	if (!buf[6] & 0x40) {
> +	if (!(buf[6] & 0x40)) {
>  		printk(DRIVER_NAME": Disc type is not CD-RW\n");
>  		return 1;
>  	}
> -	if (!buf[6] & 0x4) {
> +	if (!(buf[6] & 0x4)) {

Roel, many of this were fixed during
"+ fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch added to -mm tree"
thread. Please, check patches in there and send what was missed.
