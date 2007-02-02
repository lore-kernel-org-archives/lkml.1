Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbXBBLH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbXBBLH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 06:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbXBBLH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 06:07:58 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47533 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbXBBLH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 06:07:57 -0500
Message-ID: <45C31B86.6070009@garzik.org>
Date: Fri, 02 Feb 2007 06:07:50 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Michael K. Edwards" <medwards.linux@gmail.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Should io(read|write)(8|16|32)_rep take (const|) volatile u(8|16|32)
 __iomem *addr?
References: <f2b55d220702011624v6cb13c8ct1d70863a661d2227@mail.gmail.com> <f2b55d220702011635s5b338a6ct861645ea7892f732@mail.gmail.com> <45C2D47A.9080001@garzik.org> <45C2DA8D.4050007@zytor.com>
In-Reply-To: <45C2DA8D.4050007@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeff Garzik wrote:
>> Volatile is usually reserved for a specific need on a specific arch.  
>> I doubt it is correct to force it on all arches.
> 
> They already are volatile; the issue is adding "const".
> 
> All io(read|write)* pointers are volatile, IIRC.

No, none are volatile, hence my comment.

> [jgarzik@pretzel linux-2.6]$ grep volatile lib/iomap.c include/asm-generic/iomap.h 
> [jgarzik@pretzel linux-2.6]$ 

Maybe you were thinking about writel() and friends, whose implementation 
(not prototype!) includes use of volatile.

Regards,

	Jeff



