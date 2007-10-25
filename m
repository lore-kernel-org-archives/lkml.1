Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbXJYIDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbXJYIDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbXJYICo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:02:44 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:44704 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450AbXJYICm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:02:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UAw1UtoZ7lfDQs+j7BFwy8c5y4oPmJ5u1577BOFeRbwnCJggDVgAJ0obiFaCOM5Mz377vtPrWca65ZWcB4v/1xOK5iA2EHSrFvIpSGwg//D38Z25LtjO7Jx1X2/vaXAuMp8vyRsG/aH1i52KMoJCUltgNNm3VphXrZnKV2BQ9YQ=
Message-ID: <877aabc40710250102l7d4cff9ei5c7c3a40b084b32c@mail.gmail.com>
Date: Thu, 25 Oct 2007 13:32:33 +0530
From: "Amit Shah" <amitshah@gmx.net>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: Panic in gart_map_sg
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071025071239.GA5053@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <877aabc40710250012se0afe99s819207e72726d333@mail.gmail.com>
	 <20071025071239.GA5053@kernel.dk>
X-Google-Sender-Auth: 4b5e589edf41bbff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/10/2007, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, Oct 25 2007, Amit Shah wrote:
> > I get a kernel panic at gart_map_sg+0x201/0x470, which is around here:

...

> Tomo already nailed this one, see below.
>
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] x86: pci-gart fix
>
> map_sg could copy the last sg element to another position (if merging
> some elements). It breaks sg chaining. This copies only
> dma_address/length instead of the whole sg element.

Thanks, this fixed it.

-- 
Amit Shah
http://www.amitshah.net/
