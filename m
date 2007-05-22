Return-Path: <linux-kernel-owner+w=401wt.eu-S1764099AbXEVJd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764099AbXEVJd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbXEVJdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:33:50 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42790 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbXEVJdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:33:49 -0400
Message-ID: <4652B90F.2090004@cs.helsinki.fi>
Date: Tue, 22 May 2007 12:34:07 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Nitin Gupta <nitingupta910@gmail.com>
CC: linux-kernel@vger.kernel.org, Richard Purdie <richard@openedhand.com>
Subject: Re: [RFC] LZO1X de/compression support
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>	 <84144f020705180342j4ff44d96iea5b73c23a69df0f@mail.gmail.com>	 <4cefeab80705220154k2b02a264id7774600087a80e5@mail.gmail.com>	 <4652B0E3.5090601@cs.helsinki.fi> <4cefeab80705220210s98c6784k76c9d9752676112a@mail.gmail.com>
In-Reply-To: <4cefeab80705220210s98c6784k76c9d9752676112a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> Ok. I will make them inline functions now.

Btw, the only reason why any sane compiler would not inline
them is because it has reason to believe the end-result will
be more efficient. AFAIK you only need to use
__always_inline where it matters for correctness (like, for
example, in mm/slab.c) with GCC 4.0 and up.
