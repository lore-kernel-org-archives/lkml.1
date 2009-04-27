Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbZD0Hso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbZD0Hso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 03:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbZD0HsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 03:48:24 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:41978 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376AbZD0HsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 03:48:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=f6i5fGQCp8x5tMI9qHlJeNEdw90a7n9LZhrCiw9Ec438HOsorvfXKvZD0tvM9yHz3s
         sWTT7wFGu9VWJGTnx2+Nki5mufhSrUe8vVZb0j98/wy2ESsz+lUMCSlnvx+5No0bc1Nn
         YR+UNCFmUjZ/RIZbFfsQMGNKNdgMql02Lx7yA=
MIME-Version: 1.0
In-Reply-To: <20090424183517.GB23140@ovro.caltech.edu>
References: <20090424183517.GB23140@ovro.caltech.edu>
Date: Mon, 27 Apr 2009 15:48:21 +0800
X-Google-Sender-Auth: d0f7d8123b4c6827
Message-ID: <2a27d3730904270048g1e247797s6a25f9e28d664214@mail.gmail.com>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
From: Li Yang <leoli@freescale.com>
To: Ira Snyder <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 2:35 AM, Ira Snyder <iws@ovro.caltech.edu> wrote:
> By default, the Freescale 83xx DMA controller uses the PCI Read Line
> command when reading data over the PCI bus. Setting the controller to use
> the PCI Read Multiple command instead allows the controller to read much
> larger bursts of data, which provides a drastic speed increase.
>
> The slowdown due to using PCI Read Line was only observed when a PCI-to-PCI
> bridge was between the devices trying to communicate.
>
> A simple test driver showed an increase from 4MB/sec to 116MB/sec when
> performing DMA over the PCI bus. Using DMA to transfer between blocks of
> local SDRAM showed no change in performance with this patch. The dmatest
> driver was also used to verify the correctness of the transfers, and showed
> no errors.
>
> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>

Acked-by: Li Yang <leoli@freescale.com>

Thanks,
Leo
