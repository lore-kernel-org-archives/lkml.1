Return-Path: <linux-kernel-owner+w=401wt.eu-S1423149AbXBBGa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423149AbXBBGa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 01:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423140AbXBBGa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 01:30:58 -0500
Received: from terminus.zytor.com ([192.83.249.54]:51901 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423151AbXBBGa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 01:30:57 -0500
Message-ID: <45C2DA8D.4050007@zytor.com>
Date: Thu, 01 Feb 2007 22:30:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "Michael K. Edwards" <medwards.linux@gmail.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Should io(read|write)(8|16|32)_rep take (const|) volatile u(8|16|32)
 __iomem *addr?
References: <f2b55d220702011624v6cb13c8ct1d70863a661d2227@mail.gmail.com> <f2b55d220702011635s5b338a6ct861645ea7892f732@mail.gmail.com> <45C2D47A.9080001@garzik.org>
In-Reply-To: <45C2D47A.9080001@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Volatile is usually reserved for a specific need on a specific arch.  I 
> doubt it is correct to force it on all arches.

They already are volatile; the issue is adding "const".

All io(read|write)* pointers are volatile, IIRC.

	-hpa
