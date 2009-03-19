Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbZCSCaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbZCSCaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 22:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZCSCaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 22:30:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:32561 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbZCSCaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 22:30:20 -0400
MIME-Version: 1.0
In-Reply-To: <84144f020903181221t480caa5dhef0e581a7bef006@mail.gmail.com>
References: <49BF8ABC.6040805@vflare.org> <49BF8B8B.40408@vflare.org>
	 <alpine.DEB.1.10.0903171237180.21582@qirst.com>
	 <d760cf2d0903171028o600dc94cn7a5238520d104455@mail.gmail.com>
	 <alpine.DEB.1.10.0903171355410.26058@qirst.com>
	 <49C11088.7000205@vflare.org>
	 <alpine.DEB.1.10.0903181258110.15570@qirst.com>
	 <d760cf2d0903181029r43bf417u502b46e08348f6ae@mail.gmail.com>
	 <84144f020903181221t480caa5dhef0e581a7bef006@mail.gmail.com>
Date: Thu, 19 Mar 2009 08:00:17 +0530
Message-ID: <d760cf2d0903181930m782932a4reda3a0b582489f5d@mail.gmail.com>
Subject: Re: [PATCH 2/3]: xvmalloc memory allocator
From: Nitin Gupta <ngupta@vflare.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 12:51 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Wed, 18 Mar 2009, Nitin Gupta wrote:
>>>> > Slab memory is not backed by vmalloc space.
>>>> Oh, it uses "low memory". Still not good for compcache :)
>
> On Wed, Mar 18, 2009 at 10:28 PM, Christoph Lameter
> <cl@linux-foundation.org> wrote:
>>> Only if you use 32 bit.
>
> On Wed, Mar 18, 2009 at 10:29 AM, Nitin Gupta <ngupta@vflare.org> wrote:
>> Yes, this point is for 32-bit only - many users were unhappy with
>> compcache size limit due to small vmalloc area on x86-32.
>
> Yeah, I can see the point in having a custom allocator for this. But
> quite frankly the xvmalloc code is just too ugly to live with. You
> might want to make it look like kernel code as per CodingStyle and
> change the name to something less generic.
>

I can see quite some places for cleanups (like macros for
reaching next free block etc). Do you think CamelCase will be acceptable
for now? and also keeping xvmalloc name? Other than these, I will
check for potential cleanups and send updated diffs.

Thanks,
Nitin
