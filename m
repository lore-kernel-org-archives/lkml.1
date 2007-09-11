Return-Path: <linux-kernel-owner+w=401wt.eu-S933966AbXIKU7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966AbXIKU7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbXIKU72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:59:28 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:36409 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758628AbXIKU72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:59:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=y4ROcySMyCiM4Zjz68/UJKo3lCi1baWz9EDCR3JOxKV7y4QgzTmMOAJEvXaKTj+ctdzk+kp1AoGhO8XPYolYZx6KsTuzokxvr4OAjS//BDkBoaom7m3wRXG2HcNKROhxnEy7/WuwNmyrnSG8jl7WTkF15aWCibEdhIkwCx34saE=  ;
X-YMail-OSG: .4TjFHsVM1lAT2yVqmfDLJgmkAdYFuUuFsIKeswlPupkSUS6gnqCM7gB9Ux.J0E5Nsxuwygzxg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 11 Sep 2007 15:17:51 +1000
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
Message-Id: <200709111517.52520.nickpiggin@yahoo.com.au>
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

And BTW, before you accuse me of FUD, I'm actually talking about the
fragmentation issues on which Mel I think mostly agrees with me at this
point.

Also have you really a rational reason why we should just up and accept
all these big changes happening just because that, while there are lots
of theoretical issues, the person pointing them out to you hasn't happened
to give you a concrete failure case. Oh, and the actual performance
benefit is actually not really even quantified yet, crappy hardware not
withstanding, and neither has a proper evaluation of the alternatives.

So... would you drive over a bridge if the engineer had this mindset?
