Return-Path: <linux-kernel-owner+w=401wt.eu-S935126AbYBCA2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935126AbYBCA2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765278AbYBCA2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:28:14 -0500
Received: from www.tglx.de ([62.245.132.106]:41530 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbYBCA2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:28:13 -0500
Date: Sun, 3 Feb 2008 01:27:58 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Denis Cheng <crquan@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       cr_quan@163.com
Subject: Re: [PATCH 2/3] uio: mark pci_device_id hilscher_pci_ids[]
 __devinitdata
Message-ID: <20080203012758.3e7c370c@dilbert.local>
In-Reply-To: <1201945897-32297-2-git-send-email-crquan@gmail.com>
References: <<1201945897-32297-1-git-send-email-crquan@gmail.com>
	<1201945897-32297-2-git-send-email-crquan@gmail.com>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sat,  2 Feb 2008 17:51:36 +0800
schrieb Denis Cheng <crquan@gmail.com>:

Makes sense.

> Signed-off-by: Denis Cheng <crquan@gmail.com>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> ---
>  drivers/uio/uio_cif.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/uio/uio_cif.c b/drivers/uio/uio_cif.c
> index 838bae4..4a5a97e 100644
> --- a/drivers/uio/uio_cif.c
> +++ b/drivers/uio/uio_cif.c
> @@ -116,7 +116,7 @@ static void hilscher_pci_remove(struct pci_dev
> *dev) kfree (info);
>  }
>  
> -static struct pci_device_id hilscher_pci_ids[] = {
> +static struct pci_device_id hilscher_pci_ids[] __devinitdata = {
>  	{
>  		.vendor =	PCI_VENDOR_ID_PLX,
>  		.device =	PCI_DEVICE_ID_PLX_9030,
