Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZAEVDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZAEVDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZAEVDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:03:22 -0500
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:53023 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755254AbZAEVDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:03:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=jYFNck9Y6RNmhrKQabKSrPqU3nleeNgXumnuaNenHTPqxltF+ReXISM7jF5Dvxnb4m98L1XufTMh+HAh9jYSQOqcpE4NQ/IX7iuWGrSnEVqvI9MRg5h3FsB6YH7sEkYi;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] aerdrv: fix sanity check in report_resume
Date: Mon, 5 Jan 2009 13:03:19 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.9-73.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-pci@vger.kernel.org, tom.l.nguyen@intel.com, yanmin.zhang@intel.com,
       linux-kernel@vger.kernel.org
References: <493392BA.50906@jp.fujitsu.com>
In-Reply-To: <493392BA.50906@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051303.19749.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 30, 2008 11:31 pm Hidetoshi Seto wrote:
> What we have to check here before calling it is err_handler->resume.
> It seems that this block have been copy&pasted from report_slot_reset.
>
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  drivers/pci/pcie/aer/aerdrv_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c
> b/drivers/pci/pcie/aer/aerdrv_core.c index dfc63d0..aac7006 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -252,7 +252,7 @@ static void report_resume(struct pci_dev *dev, void
> *data)
>
>  	if (!dev->driver ||
>  		!dev->driver->err_handler ||
> -		!dev->driver->err_handler->slot_reset)
> +		!dev->driver->err_handler->resume)
>  		return;
>
>  	err_handler = dev->driver->err_handler;

Applied (again).  Hope it doesn't get lost again between now & when I send the 
pull.  Sorry about that.

-- 
Jesse Barnes, Intel Open Source Technology Center

