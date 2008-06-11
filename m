Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYFKF5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYFKF5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 01:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYFKF5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 01:57:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:46235 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbYFKF5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 01:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ttjE1sQBdEGrHsKnBNUPHLnNB30GfYHv+GD3hPHowyPWGkxz0Z5BQSf0pFUL9TJAOx
         +2+NTL/DaQCqeQhsmhqJxS+FOJ1hcCD4+tixlpRFr3m1f41A+wZbAbVdRPKbwugaboAZ
         34kDygmwIJpjGy5wyitF1/2r54yiim4uHUmh0=
Message-ID: <a44ae5cd0806102257x61596782tc523de8c866cb58b@mail.gmail.com>
Date: Wed, 11 Jun 2008 01:57:30 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
Cc: "Michael Buesch" <mb@bu3sch.de>, "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <484F5DB2.4050705@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0806100709rf4602f2x587631852502c0b5@mail.gmail.com>
	 <200806101637.11473.mb@bu3sch.de>
	 <19f34abd0806100742v176f50e8se463d2e70df44332@mail.gmail.com>
	 <200806101650.27180.mb@bu3sch.de>
	 <a44ae5cd0806101509x5e2d5c19y10101ea0e72f8cba@mail.gmail.com>
	 <484F0AF7.6060008@lwfinger.net>
	 <a44ae5cd0806101857q54074c83w2eb470682b58a6cc@mail.gmail.com>
	 <484F5DB2.4050705@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The line that fails is
>
> if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))
>
> The value at 0x58(%eax) is zero, which corresponds to the "struct b43_wldev
> *dev" line in struct b43_dmaring. In other words, ring->dev is NULL, which
> causes the error. I'll leave it to FUJITA Tomonori to figure out why.

Thanks all,

I might have time in the morning to test one more patch, otherwise I
will be back in about three weeks.

Best wishes,

        Miles
