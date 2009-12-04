Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbZLDXzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbZLDXzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757413AbZLDXzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:55:09 -0500
Received: from outbound-mail-149.bluehost.com ([67.222.38.39]:52234 "HELO
	outbound-mail-149.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755236AbZLDXzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:55:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hWNIh/pNoGgIc/zLVsLLSh2XTJzFxcA5hmfdK9gcCRRSbcUV/Nrxw0OfHu8kD3O3tQ4ERWOg21ozdzD6Dsr/APyyKa1+3y+ApBl9viDKxQSIiO9q24Au6BFtFDKeqrJi;
Date: Fri, 4 Dec 2009 15:54:28 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/2] EDAC: add __init to i7core_xeon_pci_fixup
Message-ID: <20091204155428.307e612d@jbarnes-piketon>
In-Reply-To: <1259612382-32722-1-git-send-email-jslaby@suse.cz>
References: <1259612382-32722-1-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 21:19:41 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> It's called only from an __init function and is the only user
> of pcibios_scan_specific_bus which will be marked as __devinit in
> the next patch.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/edac/i7core_edac.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
> index 4de5a18..c7fc0d5 100644
> --- a/drivers/edac/i7core_edac.c
> +++ b/drivers/edac/i7core_edac.c
> @@ -1141,7 +1141,7 @@ static void i7core_put_all_devices(void)
>  		i7core_put_devices(i7core_dev);
>  }
>  
> -static void i7core_xeon_pci_fixup(int dev_id)
> +static void __init i7core_xeon_pci_fixup(int dev_id)
>  {
>  	struct pci_dev *pdev = NULL;
>  	int i;

I don't know who handles EDAC patches, but I'm pretty sure it's not
me. :)  It doesn't apply to my tree anyway, so it probably needs a
refresh.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
