Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYJPBDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYJPBDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 21:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYJPBDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 21:03:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49833 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYJPBDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 21:03:42 -0400
Message-ID: <48F692E9.2080008@zytor.com>
Date: Wed, 15 Oct 2008 18:03:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016002509.GA25868@kroah.com>
In-Reply-To: <20081016002509.GA25868@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 
> Yes, we can handle the major/minor macros in the kernel to provide a
> compatible number so that automated scripts will not break, that's not a
> big deal.
> 
> Any thoughts?
> 
> Let the bike-shedding begin!
> 

Personally I find that having a simple counter is kind of nice, simply 
because one can talk about 27, 28, 29, ... and actually be able to rely 
on it being stable.

The 2.6 prefix has clearly outlived its utility.  The easiest way to 
deal with that is of course to simply drop it, but perhaps the best 
thing to do would be to bump the major number to 3, and start out with 
3.0 instead of 2.6.28, 3.1 for 2.6.29 and so on.  This has the advantage 
that we still retain the major number for "huge changes".

On the other hand, a number of projects have gone to simple counters for 
version numbers, without a leading major.  Just having *one* number (or 
two for point releases) compensates to a large degree for the numbers 
being large.  Given that, we could just make it version 3 instead of 
2.6.28, 4 instead of 2.6.29 and so on.

	-hpa
