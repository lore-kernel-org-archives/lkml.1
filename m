Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbYJQDc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbYJQDc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 23:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYJQDcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 23:32:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:53366 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYJQDcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 23:32:19 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <adatzbbap8a.fsf@cisco.com>
References: <48F409E9.3030501@zytor.com>
	 <20081013.223811.174710738.davem@davemloft.net>
	 <Pine.LNX.4.64.0810161030120.9022@vixen.sonytel.be>
	 <20081016.013850.85183428.davem@davemloft.net>
	 <1224212533.7654.60.camel@pasglop> <1224212791.7654.63.camel@pasglop>
	 <adatzbbap8a.fsf@cisco.com>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 14:31:54 +1100
Message-Id: <1224214314.7654.65.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 20:13 -0700, Roland Dreier wrote:
> > + * Right now we handle:
>  > + *
>  > + * - 'F' For symbolic Function descriptor pointers
>  > + * - 'S' For Symbolic direct pointers), but this can easily be
>  > + *       extended in the future (network address types etc).
>  > + * - 'R' For a struct resouce pointer, it prints the range of
>  > + *       addresses (not the name nor the flags)
> 
> A little too much cut and paste -- the "easily be extended" bit at 'S'
> doesn't really make sense in the middle of the list.

Right :-)

>  > + * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
>  > + * function pointers are really function descriptors, which contain a
>  > + * pointer the real address.
> 
> you cut and pasted Linus's typo too -- "a pointer the real address"
> should probably be "a pointer *TO* the real address"

Ok, I'll wait for more comments before a respin to :-) I'm mostly
wondering whether to use fixed sized format rather than the current
variable size (and pad with zeros).

Cheers,
Ben.


