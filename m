Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0BPOCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:02:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756396Ab0BPOCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:02:21 -0500
Date: Tue, 16 Feb 2010 15:01:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Was: x86: get rid of the insane TIF_ABI_PENDING bit
Message-ID: <20100216140126.GA16448@redhat.com>
References: <20100215161752.GA19962@redhat.com> <4B799C3F.7010308@zytor.com> <20100215194123.96D49FC3@magilla.sf.frob.com> <4B79B202.5090006@zytor.com> <20100216101903.GA1057@redhat.com> <20100216102332.GL21783@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216102332.GL21783@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Andi Kleen wrote:
>
> On Tue, Feb 16, 2010 at 11:19:03AM +0100, Oleg Nesterov wrote:
> >
> > Agreed, but otoh it is always good to understand the code. If we
> > really have a reason for TS_COMPAT, a small comment can help other
> > readers.
>
> My memory is somewhat fuzzy on this one, but I think it was related
> to VMA placement (probably for stack randomization or something like that)
> This happens before the first call. I might be wrong on that.

Afaics we never check TS_COMPAT/is_compat_task for this...

> There might also have been other is_compat_task checks in the exec init
> path, so partly it was defensive programming.

Understand, but it looks so confusing...

OK. Please feel free to ignore, but I am sending the trivial, but only
compile-tested patches. My main motivation is to simplify the reading
and understanding of this code.

The first patch looks like an "obvious" bugfix for 2.6.33 though, but
still untested.

Oleg.

