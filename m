Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbZALUlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbZALUlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbZALUlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:41:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52180 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811AbZALUlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:41:18 -0500
Date: Mon, 12 Jan 2009 21:55:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?R=E9mi?= Denis-Courmont <rdenis@simphalempin.com>
Cc: Andi Kleen <andi@firstfloor.org>, Valdis.Kletnieks@vt.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Michael Stone <michael@laptop.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: RFC: Network privilege separation.
Message-ID: <20090112205547.GE23848@one.firstfloor.org>
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <200901122215.27842.rdenis@simphalempin.com> <20090112203931.GD23848@one.firstfloor.org> <200901122230.25976.rdenis@simphalempin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901122230.25976.rdenis@simphalempin.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 10:30:25PM +0200, Rémi Denis-Courmont wrote:
> Le lundi 12 janvier 2009 22:39:31 Andi Kleen, vous avez écrit :
> > > What's the point of writing a parser (that could also have bugs) when the
> >
> > Sorry you lost me. What do you mean with parser here?
> >
> > > kernel can do it?
> >
> > And what does it have to do with the kernel?
> 
> The parser at the other end of the pipe. The more intricate the over-the-pipe 
> protocol is, the more likely it is to be buggy and the security scheme to 
> break.

That would be very little code that would also not 
change very often so that it could be probably effectively
audited.

> > Yes it would be somewhat slower, but if it avoids a couple of security
> > updates that would be probably worth it.
> 
> If codecs did not care about performance, they'd be written in some high-level 
> language that could easily be sandboxed by its own VM.

I don't think using a full JIT is anywhere comparable in 
performance impact to adding two cache hot copies to 
otherwise fully optimized code.

> 
> As the guy who's been dealing with VLC security issues for the past two years, 
> I have to say, I am in no way interested in SECCOMP as it _currently_ is.

Fair point, although I'm afraid you didn't do a very good
job explaining your reasons, so it sounds like a 
quite arbitary decision.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
