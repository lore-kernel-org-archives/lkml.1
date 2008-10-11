Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbYJKLXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbYJKLXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 07:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYJKLXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 07:23:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57364 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbYJKLXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 07:23:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Update cacheline size on X86_GENERIC
Date: Sat, 11 Oct 2008 13:27:26 +0200
User-Agent: KMail/1.9.9
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Dave Jones <davej@redhat.com>,
       x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
References: <20081009171453.GA15321@redhat.com> <200810111929.19891.nickpiggin@yahoo.com.au> <20081011112218.GA12131@one.firstfloor.org>
In-Reply-To: <20081011112218.GA12131@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810111327.27121.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 11 of October 2008, Andi Kleen wrote:
> On Sat, Oct 11, 2008 at 07:29:19PM +1100, Nick Piggin wrote:
> > I also think there are reasonable arguments the other way, and I
> > personally also think it might be better to leave it 128 (even
> > if it is unlikely, introducing a regression is not good).
> 
> The issue is also that the regression will be likely large.
> False sharing can really hurt when it hits as you know, because
> the penalties are so large.
> 
> > > There are millions and millions of P4s around.
> > > And they're not that old, they're still shipping in fact.
> > 
> > Still shipping in anything aside from 1s systems?
> 
> Remember the first Core2 based 4S (Tigerton) Xeon was only introduced last year 
> and that market is quite conservative. For 2S it's a bit longer, but
> it wouldn't surprise me there if new systems are still shipping.
> 
> Also to be honest I doubt the theory that older systems
> are never upgraded to newer OS.

Actaually, I have examples to the contrary. :-)

Thanks,
Rafael
