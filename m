Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbXJYMQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbXJYMQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 08:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXJYMQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 08:16:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:33410 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbXJYMQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 08:16:23 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: Is gcc thread-unsafe?
Date: Thu, 25 Oct 2007 14:16:19 +0200
User-Agent: KMail/1.9.6
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <200710251324.49888.nickpiggin@yahoo.com.au> <200710250915.50675.ak@suse.de> <Pine.LNX.4.61.0710250753350.22665@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0710250753350.22665@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251416.19606.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 13:58:56 linux-os (Dick Johnson) wrote:
> 
> On Thu, 25 Oct 2007, Andi Kleen wrote:
> 
> > On Thursday 25 October 2007 05:24, Nick Piggin wrote:
> >
> >> Basically, what the gcc developers are saying is that gcc is
> >> free to load and store to any memory location, so long as it
> >> behaves as if the instructions were executed in sequence.
> >
> > This case is clearly a bug, a very likely code pessimization.
> > I guess it wasn't intentional, just an optimization that is useful
> > for local register values doing too much.
> 
> 
> I don't think it is a BUG,

Bug as in an optimization that makes the code slower than it was
before. That is clearly a bug in a compiler.

-Andi
