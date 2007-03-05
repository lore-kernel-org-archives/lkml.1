Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbXCEUot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbXCEUot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932375AbXCEUot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:44:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:35766 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371AbXCEUos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:44:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=NxqOveZg8VOUq3oYplXxEeiFsvQdD6EsYsyT6nBxfjHqaWJCBtVzuaSOqChQF7ElqW++ajAXz2faVnzkAyrnBGgSAhrflxZ6lRuMHzQ0G1ud7PioSkvqOCi07JkCsKb6TDCDqpQCjZfqnbv2z9enWuxhu6mETRUL7jxsZG2Sft8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jon Wikne <wikne@cheetah.uio.no>
Subject: Re: piix.c - previously available patch not implemented
Date: Mon, 5 Mar 2007 21:51:29 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <45EC654F.7030209@cheetah.uio.no>
In-Reply-To: <45EC654F.7030209@cheetah.uio.no>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703052151.29312.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 05 March 2007, Jon Wikne wrote:
> Hi list,
> 
> Last year, around 2.6.16.*, there was a patch around that helped
> me get the PIIX driver to run with the Intel 82801FBM (ICH6M) chip
> on my Toshiba Tecra A3 laptop.
> 
> Now, compiling the 2.6.21_rc2 kernel on this machine, to my
> astonishment I find that this patch has still not reached the
> mainstream kernel.
> 
> I do not know whether there might be a good reason for this,
> but this patch is essential for me, and most likely others as
> well. I include the patch that works for me below, ported and
> relative to piix.c version 0.46 taken from the 2.6.21_rc2.

[ ... ]

> +#define PCI_DEVICE_ID_INTEL_ICH6_5      0x2653

[ ... ]

This is SATA controller and has always been handled by ata_piix driver.
It is considered superior over piix for SATA hardware. [ at least ATM :-P ]

PS please _always_ cc: linux-ide@vger.kernel.org on Linux ATA issues

Thanks,
Bart
