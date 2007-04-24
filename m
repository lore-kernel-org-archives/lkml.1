Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbXDXING@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbXDXING (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbXDXING
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:13:06 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:45239 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbXDXINE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:13:04 -0400
Message-Id: <6.0.0.20.2.20070424165007.04921fd8@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Tue, 24 Apr 2007 17:12:31 +0900
To: Nick Piggin <nickpiggin@yahoo.com.au>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] mm: PageLRU can be non-atomic bit operation
Cc: Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <462D6FD3.2090805@yahoo.com.au>
References: <6.0.0.20.2.20070423193641.0457f700@172.19.0.2>
 <Pine.LNX.4.64.0704231202390.29015@blonde.wat.veritas.com>
 <6.0.0.20.2.20070423210926.045668d0@172.19.0.2>
 <Pine.LNX.4.64.0704231438280.3516@blonde.wat.veritas.com>
 <6.0.0.20.2.20070424100507.049670d0@172.19.0.2>
 <462D6FD3.2090805@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


At 11:47 07/04/24, Nick Piggin wrote:

 >As Hugh points out, we must have atomic ops here, so changing the generic
 >code to use the __ version is wrong. However if there is a faster way that
 >i386 can perform the atomic variant, then doing so will speed up the generic
 >code without breaking other architectures.
 >

Do you mean writing page-flags.h specific for i386 so improving generic code
and without breaking other architectures ?

