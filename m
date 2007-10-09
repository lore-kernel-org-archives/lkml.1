Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbXJJC2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbXJJC2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 22:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbXJJC2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 22:28:12 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:20777 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751537AbXJJC2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 22:28:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RzzJ5YHhRVyP5nCnQBq1/0gJ2tFWCuLG9wXpAkg1O4SxUS1YOwYRnag/KH2UAq2STkFzWd3E0rU12Uluj0NegG4JulXKbepDegAFwRtgFCj5VBuAwkjjKty29TyhlcLMNfZO6rsa/kUAh4yIX1ko0Okaav61ETmeR++NSSl0XeA=  ;
X-YMail-OSG: .hIqD5oVM1lrcUKpds6ZvBjxVVBw9C3fKaT571hFutZOLillFerhNAF0izpjSOnxQhKzzMFGrg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [13/18] x86_64: Allow fallback for the stack
Date: Tue, 9 Oct 2007 19:56:30 +1000
User-Agent: KMail/1.9.5
Cc: Rik van Riel <riel@redhat.com>, Andi Kleen <ak@suse.de>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, travis@sgi.com
References: <20071004035935.042951211@sgi.com> <200710091846.22796.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0710091825470.4500@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710091825470.4500@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710091956.30487.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 October 2007 11:26, Christoph Lameter wrote:
> On Tue, 9 Oct 2007, Nick Piggin wrote:
> > > We already use 32k stacks on IA64. So the memory argument fail there.
> >
> > I'm talking about generic code.
>
> The stack size is set in arch code not in generic code.

Generic code must assume a 4K stack on 32-bit, in general (modulo
huge cpumasks and such, I guess).


> > > > The solution has until now always been to fix the problems so they
> > > > don't use so much stack. Maybe a bigger stack is OK for you for 1024+
> > > > CPU systems, but I don't think you'd be able to make that assumption
> > > > for most normal systems.
> > >
> > > Yes that is why I made the stack size configurable.
> >
> > Fine. I just don't see why you need this fallback.
>
> So you would be ok with submitting the configurable stacksize patches
> separately without the fallback?

Sure. It's already configurable on other architectures.
