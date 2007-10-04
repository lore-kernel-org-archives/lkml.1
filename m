Return-Path: <linux-kernel-owner+w=401wt.eu-S1759871AbXJDSpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbXJDSpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbXJDSoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:44:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:50761 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbXJDSox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:44:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix blktrace setup 32-bit ioctl on 64-bit kernels
Date: Thu, 4 Oct 2007 20:44:13 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <20071002073943.GC5236@kernel.dk> <200710040048.20676.arnd@arndb.de> <20071004181606.GH5711@kernel.dk>
In-Reply-To: <20071004181606.GH5711@kernel.dk>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710042044.14698.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/34aMHe0NQz222iVHoP3cZHLDrzysFQSwbop/
 H5y8sMM/pxASst2d03/4YdRO29xHxQnRBv5APlod65RbEp+X66
 aCIgZd9nsQeWFL6Jy6WUA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 October 2007, you wrote:
> This looks a lot better! I don't mind seperating the block bits, when we
> get the whole bunch in there. Just seemed overly silly and complicated
> to do it for just one ioctl command. When you are happy with this patch,
> I'll add it to the pending block stuff for 2.6.24. The blktrace fix
> isn't a regression so need not go into 2.6.23.

ok.

> It seems some bits are missing though (like BLKTRACESETUP32), did you
> send the whole thing?

I did the large patch on top of the blktrace patch I sent earlier,
so it doesn't apply cleanly. When doing the final version, I'll use
a more sensible patch order.

	Arnd <><
