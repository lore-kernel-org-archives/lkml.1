Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbZJLOK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbZJLOK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbZJLOK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:10:27 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:44834 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712AbZJLOK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:10:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Z4pDVcGITulpm4f/5xdZBGXZkIsXJAknnJFVLdk7ZF31P5OoFTYaGSB/lkrh/9QnMD
         zeW32LfJa91ATtxJG81c2zWfMZ947nY1yV2N4Qy2Y9qr+up8CkqDaBkWd7AD5WDbdTzD
         D9bwsepQM4DWqZWjMmZ7448weRvXF8X6jZh+E=
MIME-Version: 1.0
Date: Mon, 12 Oct 2009 19:39:50 +0530
Message-ID: <b2ac5deb0910120709y59051b92s64d20374d3ef32e8@mail.gmail.com>
Subject: Booting Kernel from a Higher Physical Memory Base on x86/x86_64
From: Swapnil Pimpale <swapnil.pict@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I want to run a kernel in a higher physical offset. i.e. If I have 1
GB of memory, I want to give only upper 512 MB to the kernel and keep
lower 512 MB free (not mapped in virtual memory). Is this possible for
x86 or x86_64 architecture?

I have found that there is a PHYS_OFFSET macro in arm kernel which
makes it possible to use higher physical base address. Is there
anything similar to this for x86/x86_64?

Thanks in advance,
Swapnil Pimpale
