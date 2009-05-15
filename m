Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZEOGru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZEOGru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 02:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZEOGrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 02:47:39 -0400
Received: from mail-qy0-f112.google.com ([209.85.221.112]:47337 "EHLO
	mail-qy0-f112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZEOGri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 02:47:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wR/xfdFPkXDV3mnNhVqrY7+dbG2zu/M06ccnac7OLJFs/8rC7RqTpzjthRi2BNU+eO
         4Mtzp/0iPZqq1Vq/YtlYUR471GiTt9nTzliaqW3NKLp7NQYGNjTy27bH2rCCY42RI6kN
         MtczghApJk9SDdVkenUns66nO+9ccxnbTZhb0=
MIME-Version: 1.0
Date: Thu, 14 May 2009 23:47:39 -0700
Message-ID: <cf70f0210905142347y7738d194k5a616e7d9e4bf092@mail.gmail.com>
Subject: Understanding kernel Oops while using M-USB
From: Shivdas Gujare <shivdas.tech@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is a part of Oops on BeagleBoard, which I am trying to understand...
I have pasted complete Oops at http://pastie.org/478896

[<c0036d24>] (omap3_pm_idle+0x0/0x120) from [<c002c184>] (cpu_idle+0x40/0x60)
[<c002c144>] (cpu_idle+0x0/0x60) from [<c0299bfc>] (rest_init+0x58/0x6c)
 r5:c037ee8c r4:c0387d38
[<c0299ba4>] (rest_init+0x0/0x6c) from [<c0008a00>] (start_kernel+0x260/0x2b8)
[<c00087a0>] (start_kernel+0x0/0x2b8) from [<80008034>] (0x80008034)

--------------------end of oops------------------
c00087a0(virtual address of start_kernel) + 0x260(offset) = c0008a00
(value in square bracket above)
where c0008a00 is the address of next instruction after branch
instruction to c0299ba4(i.e rest_init)

But here, I didn't understood what is 0x2b8 from
(start_kernel+0x260/0x2b8). i.e. 0x260 is a offset from start_kernel
but what is 0x2b8?
Also what address 0x80008034 points to?

I tried to analyze this using "arm-none-linux-gnueabi-objdump -D vmlinux".

I what general scenarios "Unable to handle kernel paging request at
virtual address" this message gets printed?


Thanks for your help.

Thanks and Regards,
Shivdas Gujare
