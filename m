Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbXJYCkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbXJYCkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbXJYCkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:40:43 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:20721 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754148AbXJYCkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:40:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=U9mLoSEKXgmF6pd58XqQ7OIBlbTREcnOeIPRC9ezYWIewZSxH78gsPUMpdGiQa+6iIBmEK4r9PlDa5eNaVGabMmPs2/PjOv7ediGPUBcqMXBGk33yoXrobI+8CrOtg82GJyNnhPHTZ21qVv7NoO+ftFzNsl8oEUvdLuNmCibe2A=  ;
X-YMail-OSG: z.JGa6gVM1mAHx.QXV8.zCmy5emeJyUE7cjL1X1.qMNnQ9VsKkwT.ZL704mJJEX2Z6Iyk.oS0w--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: SLUB 0:1 SLAB (OOM during massive parallel kernel builds)
Date: Thu, 25 Oct 2007 12:34:01 +1000
User-Agent: KMail/1.9.5
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Mel Gorman <mel@skynet.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
References: <20071023181615.GA10377@martell.zuzino.mipt.ru> <20071024192849.GA3206@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0710241913220.29434@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710241913220.29434@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251234.01440.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 12:15, Christoph Lameter wrote:
> On Wed, 24 Oct 2007, Alexey Dobriyan wrote:
> > [12728.701398] DMA free:8032kB min:32kB low:40kB high:48kB active:2716kB
> > inactive:2208kB present:12744kB pages_scanned:9299 all_unreclaimable?
> > yes [12728.701567] lowmem_reserve[]: 0 2003 2003 2003 [12728.701654]
>
> Ummm... all unreclaimable is set! Are you mlocking the pages in memory? Or
> what causes this? All pages under writeback? What is the dirty ratio set
> to?

Why is SLUB behaving differently, though.

Memory efficiency wouldn't be the reason, would it? I mean, SLUB
should be more efficient than SLAB, plus have less data lying around
in queues.
