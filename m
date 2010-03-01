Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0CADqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 22:46:19 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46614 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab0CADqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 22:46:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NSu/DGXDj0zA20OTUWbtFK2t458ZC6eEDbulYzLKxEFbnu3MujuHtxL0Moe6yrUpHD
         MCD8ZW5pvhWlO+4f7ylonMICq9S0QL1NBoit+71w7Q5CCzDc18G0g3nEzW0bqR13tEFG
         zyUotCn0XHNqoQ7P0rcpQGigLaHNFBZ/7rR7E=
MIME-Version: 1.0
In-Reply-To: <1266269723-556-1-git-send-email-agust@denx.de>
References: <1266269723-556-1-git-send-email-agust@denx.de>
Date: Sun, 28 Feb 2010 20:40:03 -0700
X-Google-Sender-Auth: 01fedfd6741d53ac
Message-ID: <e9c3a7c21002281940v78f84481o278f77e4bf4782a0@mail.gmail.com>
Subject: Re: [PATCH] dmatest: correct raid6 PQ test
From: Dan Williams <dan.j.williams@intel.com>
To: Anatolij Gustschin <agust@denx.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 2:35 PM, Anatolij Gustschin <agust@denx.de> wrote:
> The number of PQ sources specified by module parameter "pq_sources"
> is always forced odd to fit into dmatest's destination verificaton
> scheme. But number of PQ sources and coefficients as passed to the
> driver's prep_dma_pq() is not adjusted accordingly.
>
> Fix it now to get correct PQ testing results in the case passed
> "pq_sources" parameter is even.
>
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
> ---
>  drivers/dma/dmatest.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

Applied... and the same problem for the xor case (I'll fix that up).

--
Dan
