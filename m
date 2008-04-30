Return-Path: <linux-kernel-owner+w=401wt.eu-S1762830AbYD3NQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830AbYD3NQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 09:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761583AbYD3NQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 09:16:27 -0400
Received: from smtp-out.google.com ([216.239.33.17]:56317 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760998AbYD3NQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 09:16:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=tjTronzFa/DvmXWa7mhSQFVe6ugQfkAlyhea4+ljrGaFcXnOVrQUqvtk2a6Kmrij5
	j5v2nw7Tui2BWBf9jdxbg==
Message-ID: <d43160c70804300616v6eb89ea8re22af1956b11f012@mail.gmail.com>
Date: Wed, 30 Apr 2008 09:16:15 -0400
From: "Ross Biro" <rossb@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: Page Faults slower in 2.6.25-rc9 than 2.6.23
Cc: "Hugh Dickins" <hugh@veritas.com>, linux-mm@kvack.org,
       lkml <linux-kernel@vger.kernel.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
In-Reply-To: <d43160c70804291000k5de1b657sc1f381e08ecaeb07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d43160c70804290610t2135a271hd9b907529e89e74e@mail.gmail.com>
	 <Pine.LNX.4.64.0804291447040.5058@blonde.site>
	 <661de9470804290752w1dc0cfb3k72e81d828a45765e@mail.gmail.com>
	 <d43160c70804290821i2bb0bc17m21b0c5838631e0b8@mail.gmail.com>
	 <Pine.LNX.4.64.0804291629410.23101@blonde.site>
	 <48175005.90400@linux.vnet.ibm.com>
	 <d43160c70804291000k5de1b657sc1f381e08ecaeb07@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 1:00 PM, Ross Biro <rossb@google.com> wrote:
> > Aah.. Yes... but I am definitely interested in figuring out the root cause for
>  > the regression.
>
>  I can't reproduce the 2.6.23 results.  I'm going to run the benchmarks
>  a few more times, but I'm suspecting something changed with the
>  hardware.

The 2.6.23 results have been consistant with 2.6.24 results and
lmbench has crashed my test machine at least once.  I'm guessing some
sort of memory error causing a lot of ECC and slowing things down.

    Ross
