Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYIYOxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYIYOxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYIYOxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:53:06 -0400
Received: from outbound-mail-13.bluehost.com ([69.89.18.113]:48790 "HELO
	outbound-mail-13.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753521AbYIYOxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:53:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=g9y3L2wlfADsSTdyZ0mxkPTFxswouKv6k/ZQrqOf8np7B4umOUq+zYm+vtMgNVNkrfFH81Wo0vRi5ESgGgtrk/oZ8a0aZlAs7DwBwSseFTTbVp6ZHSMnSe+G6iq8PYwQ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 3/7] pci: using %pF in quirks.c
Date: Thu, 25 Sep 2008 07:52:40 -0700
User-Agent: KMail/1.9.9
Cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com> <1222308277-10984-3-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1222308277-10984-3-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809250752.42036.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 24, 2008 7:04 pm Yinghai Lu wrote:
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> ---
>  drivers/pci/quirks.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 1f26712..addf2db 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1689,8 +1689,7 @@ static void pci_do_fixups(struct pci_dev *dev, struct
> pci_fixup *f, struct pci_f if ((f->vendor == dev->vendor || f->vendor ==
> (u16) PCI_ANY_ID) && (f->device == dev->device || f->device == (u16)
> PCI_ANY_ID)) { #ifdef DEBUG
> -			dev_dbg(&dev->dev, "calling ");
> -			print_fn_descriptor_symbol("%s\n", f->hook);
> +			dev_dbg(&dev->dev, "calling %pF\n", f->hook);
>  #endif
>  			f->hook(dev);
>  		}

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
