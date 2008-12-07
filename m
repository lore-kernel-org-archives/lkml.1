Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbYLGViW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbYLGViW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 16:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYLGViM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 16:38:12 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:6758 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYLGViL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 16:38:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LfZ0J1crdlYq+IphNeKKm91ftQFqsSc+kZUqjvE/0u/QRt0TqaYV7ejHCR0GeVME25
         MDvMLA2y79A1CkyJDK0EzP1XOn6hNXASDlOistfIo/MxBf05BM8Q1wDdJ0LafdeK6rnf
         4wU9Kh+COLasZmL7KWOFc/zf/dJJZsrBgI88c=
Message-ID: <12bfabe40812071338y6bb47161le676ac9613b366cd@mail.gmail.com>
Date: Sun, 7 Dec 2008 22:38:10 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: [PROBLEM] Hw problem or software bug? DMA: Out of SW-IOMMU space....
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <493C1A2C.3080801@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812061948w4069e389ub90c4af86a493da6@mail.gmail.com>
	 <493C1A2C.3080801@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 7, 2008 at 7:47 PM, Robert Hancock <hancockr@shaw.ca> wrote:
>
> Seems like you have lots of disks, it could be you just have too much IO in
> flight at the same time for the size of the IOMMU area. You might be able to
> avoid that by increasing the SW-IOMMU size.
>
> However, your system should be AHCI capable, you should try to switch the
> SATA controller into that mode in the BIOS (possibly labelled RAID mode or
> something). Then it shouldn't need to use bounce buffers for disk access in
> the first place (plus give you NCQ support).
>
I've done what you said, now is there anything I can do to see if the
problem is solved? Use some program which produces a lot of IO? Is
there any suggested IO stress test available?
