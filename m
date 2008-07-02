Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbYGBX2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbYGBX2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 19:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYGBX21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 19:28:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbYGBX20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 19:28:26 -0400
Date: Wed, 2 Jul 2008 16:28:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: jbarnes@virtuousgeek.org, klassert@mathematik.tu-chemnitz.de,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch 03/04] 3c59x: handle pci_name() being const
Message-Id: <20080702162809.dc3ddf0e.akpm@linux-foundation.org>
In-Reply-To: <20080702202453.GC14024@kroah.com>
References: <20080702200902.909349505@mini.kroah.org>
	<20080702202453.GC14024@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 13:24:53 -0700
Greg Kroah-Hartman <gregkh@suse.de> wrote:

> This changes vortex_prob1() to handle pci_name() now returning a
> constant string.
> 
> Cc: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/net/3c59x.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/net/3c59x.c
> +++ b/drivers/net/3c59x.c
> @@ -1010,7 +1010,7 @@ static int __devinit vortex_probe1(struc
>  	static int printed_version;
>  	int retval, print_info;
>  	struct vortex_chip_info * const vci = &vortex_info_tbl[chip_idx];
> -	char *print_name = "3c59x";
> +	const char *print_name = "3c59x";
>  	struct pci_dev *pdev = NULL;
>  	struct eisa_device *edev = NULL;
>  	DECLARE_MAC_BUF(mac);
> 

Well this one applied.  The others didn't.

Please prefer to not raise patches against a 30MB-old kernel ;)
