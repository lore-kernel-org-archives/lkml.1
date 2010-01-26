Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950Ab0AZTVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab0AZTVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857Ab0AZTVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:21:23 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:5495 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab0AZTVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:21:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=AKwGEPG/gTxSSHef4U3HGHTVuYuK1/2/m47D/XiOkG0AcX+TZGnDVkMVrxMFiMxzRh
         +STrCvogu7aNX1S1P4rpLLMaYQTNvgq+9+oVZFd+FcqpyutecglV2i9aTeebBvgS9oDN
         9n7sxZ1XyX+QL29jYTYJWHlI8r0NHTFTiZLL0=
MIME-Version: 1.0
Date: Tue, 26 Jan 2010 19:21:21 +0000
Message-ID: <74fd948d1001261121r7e6d03a4i75ce40705abed4e0@mail.gmail.com>
Subject: BUG at mm/slab.c:2990 with 2.6.33-rc5-tuxonice
From: Pedro Ribeiro <pedrib@gmail.com>
To: linux-kernel@vger.kernel.org, Nigel Cunningham <ncunningham@crca.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hit a bug at mm/slab.c:2990 with .33-rc5.
Unfortunately nothing more is available than a screen picture with a
crash dump, although it is a good one.
The bug was hit almost at the end of a hibernation cycle with
Tux-on-Ice, while saving memory contents to an encrypted swap
partition.

The image is here http://img264.imageshack.us/img264/9634/mmslab.jpg (150 kb)

Hopefully it is of any use for you. Please let me know if you need any
more info.

Regards,
Pedro
