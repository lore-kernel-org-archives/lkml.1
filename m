Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbYBMEmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbYBMEmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 23:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYBMEmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 23:42:16 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:39862 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753188AbYBMEmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 23:42:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bhRTzPRBpmQ6/JE2Vv1cEARgtyRkyWwRSkzp2WAqPQBqb1uAF6FlpA5O52d74Gof7PgqrJwumJ2iQuKJT+qR0wwtD0ziowua4Eb4L/0b2ZhR/+KhpzBW6yqSE4LsnyVXbEqIRuC50V+z7hC/sTuM+vLjEVUiII3blJsOTiQODJg=  ;
X-YMail-OSG: .qHqlwEVM1ki66ovBrTvecPtQu2jq8OYTB4CrMhp1xd8yqoxZp60N.zdXoZ5OrqimyzVDG..KA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: 2.6.24-sha1: RIP  [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
Date: Wed, 13 Feb 2008 15:42:02 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20080210140031.GA1754@martell.zuzino.mipt.ru> <20080212222704.GC2144@martell.zuzino.mipt.ru> <200802131117.37389.nickpiggin@yahoo.com.au>
In-Reply-To: <200802131117.37389.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131542.03026.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008 11:17, Nick Piggin wrote:
> On Wednesday 13 February 2008 09:27, Alexey Dobriyan wrote:

> > It's a trivial dumb module which does nothing but loads and unloads.
> > I redid ftest03 later without any suspicious activity and it oopsed the
> > same way.
>
> Ah crap. Hmm, maybe I didn't consider all cases with my last patch to
> that code... is there an easy way to get the ftest03 source and run
> it?

OK I didn't realise it is a test from ltp.

But I can't reproduce it for the life of me with the latest git kernel
and latest ltp tarball.

Is it easy to reproduce? Are you reproducing it simply by running the
ftest03 binary directly from the shell? How many times between oopses?
It is multi-process but no threads, so races should be minimal down
this path -- can you get an strace of the failing process?

Thanks,
Nick
