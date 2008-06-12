Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbYFLLVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbYFLLVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 07:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYFLLVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 07:21:18 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:22463 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751993AbYFLLVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 07:21:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YMicHSjc5140s7SH/6TFRadapt8fD9PRqByv9ovgDmLFQnVRRdgSNMznhFikxd+SFH6HxQFCytAg4EUTNJbM8eKU5G1ly9LRyEsVCADkMwlMfgK98sp3+5gg1Ffw4hEWvZy9q4Fs/ndVicwqRXH+r7oCesfD4SBeL+UuTYPVfks=  ;
X-YMail-OSG: sR0n8xAVM1nZDSirunElT4IXLJjtjV4EPfOLgRqdM5WEXLtt.mbsUirxCtFhQ5U759BXQHlfWws262gWYMJ7W7KlaBHIMGMadzxMZV.c8mvhNJDo91Wq69ZEO1wfiuh2PbA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Martin Peschke <mp3@de.ibm.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu operations
Date: Thu, 12 Jun 2008 21:21:09 +1000
User-Agent: KMail/1.9.5
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>
References: <20080530035620.587204923@sgi.com> <200806121340.29366.nickpiggin@yahoo.com.au> <1213263470.25502.6.camel@kitka.ibm.com>
In-Reply-To: <1213263470.25502.6.camel@kitka.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806122121.09835.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 19:37, Martin Peschke wrote:
> On Thu, 2008-06-12 at 13:40 +1000, Nick Piggin wrote:
> > On Thursday 12 June 2008 12:44, Rusty Russell wrote:

> > > Per-cpu seems to be particularly prone to over-engineering: see commit
> > > 7ff6f08295d90ab20d25200ef485ebb45b1b8d71 from almost two years ago.
> > > Grepping here reveals that this infrastructure is still not used.
> >
> > Hmm. Something like that needs the question asked "who uses this?"
> > before it is merged I guess. If it were a trivial patch maybe not,
> > but something like this that sits untested for so long is almost
> > broken by definition ;)
>
> Some code of mine which didn't make it beyond -mm used this small
> per-cpu extension. So the commit you refer to was tested.

Right, but it can easily rot after initial testing if it isn't
continually used.

Maybe this isn't the best example because maybe it still works
fine. But in general, unused, non-trivial code isn't good just
to leave around "just in case" IMO.
