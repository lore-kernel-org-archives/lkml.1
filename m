Return-Path: <linux-kernel-owner+w=401wt.eu-S967399AbXIKUZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967399AbXIKUZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758139AbXIKUZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:25:39 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:31092 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S967337AbXIKUZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:25:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=p5FHoN6ByZFrdZaANRLqn76hX/zxkmxgdD5MnbiZdOfXwhN5p6yyOjljTub6hP7GuHoHxZBHBypAI6dA8D/W+XY+pWrYmwxWN7rrklhP3hJSwbsRTuOzAqR7bfaBzX9ZX1uZLJSDGEC22aex9gVX0YgNOkEO+VuNuP5fcFav8kg=  ;
X-YMail-OSG: uE4nlusVM1mzGPttE6nc9g3CbPcfQJL8SUk..juE4T0yWRIs
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 11 Sep 2007 14:43:53 +1000
User-Agent: KMail/1.9.5
Cc: andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111256250.25781@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709111256250.25781@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111443.54380.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 06:01, Christoph Lameter wrote:
> On Tue, 11 Sep 2007, Nick Piggin wrote:
> > There is a limitation in the VM. Fragmentation. You keep saying this
> > is a solved issue and just assuming you'll be able to fix any cases
> > that come up as they happen.
> >
> > I still don't get the feeling you realise that there is a fundamental
> > fragmentation issue that is unsolvable with Mel's approach.
>
> Well my problem first of all is that you did not read the full message. It
> discusses that later and provides page pools to address the issue.
>
> Secondly you keep FUDding people with lots of theoretical concerns
> assuming Mel's approaches must fail. If there is an issue (I guess there
> must be right?) then please give us a concrete case of a failure that we
> can work against.

On the other hand, you ignore the potential failure cases, and ignore
the alternatives that do not have such cases.
