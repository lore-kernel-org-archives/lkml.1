Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbZFYOYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbZFYOYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZFYOYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:24:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:30181 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZFYOYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:24:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=H7jBqGRnBhlbFxjf4j4LTF7Si38t+QkUp36iNmuHrnYgbl2Xg/Mreas6X5DN5MAcnH
         WWV7ZwUDEAVJGlODw24S7ch9lr/XTAGXFM10O1Ap6v0A/OagjY1pY3xUxLslxnlYfJ8M
         6D6WdVH30Y2KD3xLTEBnJwJ2LmvK/0iqsT71o=
Message-ID: <4A438898.8030007@gmail.com>
Date: Thu, 25 Jun 2009 16:24:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.7 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 16/19] drivers/staging: Use PCI_VDEVICE
References: <cover.1245906151.git.joe@perches.com> <127986351d52895b618ad6bc31a704bc34ef2d97.1245906153.git.joe@perches.com>
In-Reply-To: <127986351d52895b618ad6bc31a704bc34ef2d97.1245906153.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/drivers/staging/vt6655/device_main.c
> +++ b/drivers/staging/vt6655/device_main.c
> @@ -344,7 +344,7 @@ static CHIP_INFO chip_info_table[]= {
>  };
>  
>  static struct pci_device_id device_id_table[] __devinitdata = {
> -{ 0x1106, 0x3253, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (int)&chip_info_table[0]},
> +{ PCI_VDEVICE(VIA, 0x3253), (int)&chip_info_table[0]},

Hmm, pointer chopped to 4 bytes on 64-bit. Could you fix that up too?

