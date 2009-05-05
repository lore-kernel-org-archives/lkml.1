Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbZEEB6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbZEEB6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 21:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZEEB6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 21:58:33 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4826 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbZEEB6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 21:58:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=jk5+txF4m8gFi4fgLGsmQKGFXPnTABnvgqCVbmZsLGQ+7y8/7qsbQxiVcnsiC11D2
	VQ/fo2+9tkNyBWhhsrw5A==
MIME-Version: 1.0
In-Reply-To: <db2b43030905032227u73a41ec3wa511efcef6a22169@mail.gmail.com>
References: <egHshlwQQFE.A.8CD.mpE9JB@chimera>
	 <20090428172845R.fujita.tomonori@lab.ntt.co.jp>
	 <db2b43030904280218v61fded68rc585ce9c58ba1cce@mail.gmail.com>
	 <20090428184431Z.fujita.tomonori@lab.ntt.co.jp>
	 <db2b43030905032227u73a41ec3wa511efcef6a22169@mail.gmail.com>
Date: Mon, 4 May 2009 18:58:27 -0700
Message-ID: <da824cf30905041858t2cbd0fa2x4075f387973e2700@mail.gmail.com>
Subject: Re: [Bug #13001] PCI-DMA: Out of IOMMU space
From: Grant Grundler <grundler@google.com>
To: =?UTF-8?B?0JTQsNC90LjQu9CwINCW0YPQutC+0YbQutC40Lk=?= 
	<optimusgd@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/3 Данила Жукоцкий <optimusgd@gmail.com>:
...
> WARNING: at lib/dma-debug.c:607 check_unmap+0x542/0x610()
> Hardware name: HP xw9400 Workstation
> 3w-9xxx 0001:45:00.0: DMA-API: device driver tries to free DMA memory
> it has not allocated [device address=0x0000000000000000] [size=36
> bytes]

This is definitely a driver bug. Just follow the stack trace back to
the device driver.

thanks!
grant
