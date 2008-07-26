Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbYGZRqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbYGZRqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 13:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYGZRqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 13:46:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:35849 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbYGZRqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 13:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wewYNSzmGa1Kx43cHSlP0YM22fDB5vbfhztJ94PY88HTZZTNUzKOSvkT9STv7LZdzY
         sfDc7wplxzrLcA3b72OkSGjxXtMeRmH5/IfnYyF9x5BMZN3Fa5zs4EQroO97a9ZlC8eX
         b/Qkl4bRJq88l3vwziITmZRHAq8Wk11tpFajw=
Subject: Re: [PATCH] byteorder: force in-place endian conversion to always
	evaluate args
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080726053459.GA26063@infradead.org>
References: <1217003621.5971.4.camel@brick>
	 <20080726053459.GA26063@infradead.org>
Content-Type: text/plain
Date: Sat, 26 Jul 2008 10:46:37 -0700
Message-Id: <1217094397.5971.67.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-26 at 01:34 -0400, Christoph Hellwig wrote:
> On Fri, Jul 25, 2008 at 09:33:41AM -0700, Harvey Harrison wrote:
> > David Miller reported breakage in ide when the in-place byteorder helpers
> > were used as the macros do not always evaluate their args which led to
> > an infinite loop.
> > 
> > Just make them functions to ensure they always do so.
> 
> Of course the best thing would be to kill these macros entirely.
> In-place endianess conversions are bad idea.
> 

It's better than seeing this:
	some_u32 = cpu_to_le32(some_u32);

But agreed, the 's' versions of the byteswapping api are a pretty good
sign something could be done better.

Harvey

