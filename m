Return-Path: <linux-kernel-owner+w=401wt.eu-S1759091AbYENLcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbYENLcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 07:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbYENLc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 07:32:26 -0400
Received: from baikonur.stro.at ([213.239.196.228]:51075 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbYENLcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 07:32:25 -0400
Date: Wed, 14 May 2008 13:29:50 +0200
From: maximilian attems <max@stro.at>
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       akpm@linux-foundation.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>, Mike Frysinger <vapier@gentoo.org>,
       debian-kernel@lists.debian.org
Subject: Re: asm-{alpha,h8300,um,v850,xtensa}/param.h: unbreak HZ for userspace
Message-ID: <20080514112950.GD27599@baikonur.stro.at>
References: <200805100836.48046.vapier@gentoo.org> <20080514110531.GA11775@stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514110531.GA11775@stro.at>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 01:05:31PM +0200, maximilian attems wrote:
> could we please get an ack or nack on that patch.
> checked linux-next and it doesn't appear there.
> without it currently perl 5.10 doesn't build on alpha:
> perl.c: In function 'perl_construct':
> perl.c:388: error: 'CONFIG_HZ' undeclared (first use in this function)
> -> http://buildd.debian.org/fetch.cgi?pkg=perl;ver=5.10.0-10;arch=alpha;stamp=1210252894

hmm it seems more userspace expects CONFIG_HZ, so it's not only a perl
build breakage..
