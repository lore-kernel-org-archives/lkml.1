Return-Path: <linux-kernel-owner+w=401wt.eu-S1751250AbXDHOvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbXDHOvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 10:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbXDHOvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 10:51:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:65378 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXDHOvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 10:51:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] merge compat_ioctl.h into compat_ioctl.c
Date: Sun, 8 Apr 2007 16:51:20 +0200
User-Agent: KMail/1.9.6
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
References: <20070408140433.GA28023@lst.de>
In-Reply-To: <20070408140433.GA28023@lst.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704081651.21148.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18F8P1q/+dMS6lISC9jar8Fb8JgA/g/m8s3QzQ
 /lP1mlrV4JWKK3Pjs9S+EJWN4NI+1bDDUqxgqEfrOnDTnfGIe8
 +MYp5LhygVzl2Z6LHGs2w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 April 2007, Christoph Hellwig wrote:
> 
> Now that there is no arch-specific compat ioctl handling left there
> is not point in having a separate copat_ioctl.h, so merge it into
> compat_ioctl.c

Yes, definitely a good idea.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
 
Acked-by: Arnd Bergmann <arnd@arndb.de>

On a similar subject, how about merging include/linux/ioctl32.h and the ioctl
bits of fs/compat.c into fs/compat_ioctl.c as well to make it completely
self-contained?

	Arnd <><
