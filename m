Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbZCRR32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbZCRR32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZCRR3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:29:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:53941 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbZCRR3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:29:17 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0903181258110.15570@qirst.com>
References: <49BF8ABC.6040805@vflare.org> <49BF8B8B.40408@vflare.org>
	 <alpine.DEB.1.10.0903171237180.21582@qirst.com>
	 <d760cf2d0903171028o600dc94cn7a5238520d104455@mail.gmail.com>
	 <alpine.DEB.1.10.0903171355410.26058@qirst.com>
	 <49C11088.7000205@vflare.org>
	 <alpine.DEB.1.10.0903181258110.15570@qirst.com>
Date: Wed, 18 Mar 2009 22:59:15 +0530
Message-ID: <d760cf2d0903181029r43bf417u502b46e08348f6ae@mail.gmail.com>
Subject: Re: [PATCH 2/3]: xvmalloc memory allocator
From: Nitin Gupta <ngupta@vflare.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 10:28 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Wed, 18 Mar 2009, Nitin Gupta wrote:
>
>> > Slab memory is not backed by vmalloc space.
>> Oh, it uses "low memory". Still not good for compcache :)
>
> Only if you use 32 bit.
>

Yes, this point is for 32-bit only - many users were unhappy with
compcache size limit due to small vmalloc area on x86-32.

Nitin
