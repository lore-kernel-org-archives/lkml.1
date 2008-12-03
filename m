Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYLCWAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYLCWAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 17:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYLCWAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 17:00:32 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:39750 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYLCWAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 17:00:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WnEYsBekrF4YXQMg/XTCGtr+g3v8wCBfezuuMZhGCagJKOOBubk9zacB5xMvHS0PrC
         WUhHm4o+HiScOO1kn/B5TX8tC362MtbXXxS1Pd5lxgGuHOgMEkX2wJq0nOgKofpT3ivU
         8A1FYvg9UjegHSQw0wxuBGR/aliu1OcX+AXF0=
Message-ID: <c384c5ea0812031400s58bcec3du7fc86802ad413e30@mail.gmail.com>
Date: Wed, 3 Dec 2008 23:00:30 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: edward_estabrook@agilent.com
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       edward.estabrook@gmail.com, edward.estabrook.lkml@gmail.com
In-Reply-To: <43FC624C55D8C746A914570B66D642610367F29B@cos-us-mb03.cos.agilent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43FC624C55D8C746A914570B66D642610367F29B@cos-us-mb03.cos.agilent.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Edward,

On Wed, Dec 3, 2008 at 10:39 PM,  <edward_estabrook@agilent.com> wrote:
> From: Edward Estabrook <Edward_Estabrook@agilent.com>
>
> Here is a patch that adds the ability to dynamically allocate (and use) coherent DMA from userspace by extending the userspace IO driver.  This patch applies against 2.6.28-rc6.
>
You are using a magic value to mmap(), just to keep options open:

Would this in the future allow us to also add support for streaming
non-coherent DMA directly into user space buffers?

Regards,
---
Leon
