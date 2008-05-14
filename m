Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbYENMex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbYENMex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 08:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbYENMeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 08:34:46 -0400
Received: from baikonur.stro.at ([213.239.196.228]:50308 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbYENMep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 08:34:45 -0400
Date: Wed, 14 May 2008 14:32:09 +0200
From: maximilian attems <max@stro.at>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       akpm@linux-foundation.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>, debian-kernel@lists.debian.org
Subject: Re: asm-{alpha,h8300,um,v850,xtensa}/param.h: unbreak HZ for userspace
Message-ID: <20080514123209.GE27599@baikonur.stro.at>
References: <200805100836.48046.vapier@gentoo.org> <20080514110531.GA11775@stro.at> <20080514112950.GD27599@baikonur.stro.at> <200805140812.44230.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805140812.44230.vapier@gentoo.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 08:12:42AM -0400, Mike Frysinger wrote:
> On Wednesday 14 May 2008, maximilian attems wrote:
> > On Wed, May 14, 2008 at 01:05:31PM +0200, maximilian attems wrote:
> > > could we please get an ack or nack on that patch.
> > > checked linux-next and it doesn't appear there.
> > > without it currently perl 5.10 doesn't build on alpha:
> > > perl.c: In function 'perl_construct':
> > > perl.c:388: error: 'CONFIG_HZ' undeclared (first use in this function)
> > > ->
> > > http://buildd.debian.org/fetch.cgi?pkg=perl;ver=5.10.0-10;arch=alpha;stam
> > >p=1210252894
> >
> > hmm it seems more userspace expects CONFIG_HZ, so it's not only a perl
> > build breakage..
> 
> anything using CONFIG_HZ is absolutely broken.  go fix the package.
> 
> anything using HZ should be converted to sysconf(), but i'm not about to go on 
> that crusade to fix things up

news at 11

okay great that the patch went into mm.

-- 
maks

