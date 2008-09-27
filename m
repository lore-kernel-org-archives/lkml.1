Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbYI0SN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbYI0SN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYI0SNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:13:22 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38632 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbYI0SNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:13:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=vhErtmZAe0I2tNzuv4Z4zxPdz9yj0iAJtC1dKLesMWZM5U3lYyoe2CuY9Ovc3VKGja
         Uz+zqLhgV+o1R7hub76I/I3X4nUgVRNqBV+SAr+xx1NjX+CTrdi4SCTLK8dxj1bYIIhs
         J4FEXJSrSiKtEd0bMD9m6sN4ouDDqosFKX3wE=
Message-ID: <e9c3a7c20809271113n31e00d4ax424a35d9b0836928@mail.gmail.com>
Date: Sat, 27 Sep 2008 11:13:20 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Timur Tabi" <timur@freescale.com>
Subject: Re: [PATCH v2] fsl-dma: allow Freescale Elo DMA driver to be compiled as a module
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, leoli@freescale.com
In-Reply-To: <1222293567-17694-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222293567-17694-1-git-send-email-timur@freescale.com>
X-Google-Sender-Auth: f60cb561d829021e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 2:59 PM, Timur Tabi <timur@freescale.com> wrote:
> Modify the Freescale Elo / Elo Plus DMA driver so that it can be compiled as
> a module.
>
> The primary change is to stop treating the DMA controller as a bus, and the
> DMA channels as devices on the bus.  This is because the Open Firmware (OF)
> kernel code does not allow busses to be removed, so although we can call
> of_platform_bus_probe() to probe the DMA channels, there is no
> of_platform_bus_remove().  Instead, the DMA channels are manually probed,
> similar to what fsl_elbc_nand.c does.
>
> Signed-off-by: Timur Tabi <timur@freescale.com>

Applied to async_tx.git/next.

--
Dan
