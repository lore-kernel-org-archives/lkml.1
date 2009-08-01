Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbZHAVgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbZHAVgY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 17:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbZHAVgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 17:36:24 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:41649 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbZHAVgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 17:36:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=HQ0JmofNpCJcvKa9Ozm9tj4T1RtEPsJwgFzJUi1BrBm5tZqcRb897yKjLj+f2NOage
         QWkSPlf4a3Ab5CzRVdYuF0HXFI/iwqZ52mAfiLIQtt+EmGsLS7CILymeIUVT7W6wZ70h
         PytBlAN0Gv6lbcvV2QLQQD6UUW31bdOE1Q4yo=
MIME-Version: 1.0
In-Reply-To: <438397970907311047r4b95dd16r11fdf9858bc7b772@mail.gmail.com>
References: <438397970907311047r4b95dd16r11fdf9858bc7b772@mail.gmail.com>
Date: Sat, 1 Aug 2009 14:36:23 -0700
Message-ID: <438397970908011436o29aad583p84ae40dc1df78756@mail.gmail.com>
Subject: Fwd: DMA sync operation on user space address
From: Kallol Biswas <nucleodyne@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Kallol Biswas <nucleodyne@gmail.com>
Date: Fri, Jul 31, 2009 at 10:47 AM
Subject: DMA sync operation on user space address
To: linux-arm@vger.kernel.org


 I need to implement a DMA sync (flush and invalidate) operation on
user space address.

It seems that the routine blk_dma_flush_range() that is defined in
arch/arm/mm/blockops.c can do the sync operation. Also the function
takes virtual address.

Need to consult an ARM acrh manual to find out if the processor uses
virtual addresses to access the cache. It seems so.

The question is will there be protection or any other issue calling
the above routine from kernel space while the address used as argument
is a user space address?
