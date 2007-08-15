Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbXHOF0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbXHOF0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 01:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXHOFZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 01:25:53 -0400
Received: from fed1rmmtao104.cox.net ([68.230.241.42]:35012 "EHLO
	fed1rmmtao104.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbXHOFZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 01:25:51 -0400
From: Junio C Hamano <gitster@pobox.com>
To: Joe Perches <joe@perches.com>
Cc: Rene Herman <rene.herman@gmail.com>, git@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost>
	<200708131933.10125.m.kozlowski@tuxland.pl>
	<1187026955.2688.4.camel@laptopd505.fenrus.org>
	<1187037445.6628.98.camel@heimdal.trondhjem.org>
	<1187054366.2757.0.camel@laptopd505.fenrus.org>
	<46C10AA8.3090505@gmail.com>
	<20070814102033.604c8695@the-village.bc.nu>
	<46C1CFFE.4000001@gmail.com> <1187110824.32555.76.camel@localhost>
	<7vwsvx8twx.fsf@assigned-by-dhcp.cox.net>
	<1187143925.32555.208.camel@localhost>
Date: Tue, 14 Aug 2007 22:25:45 -0700
In-Reply-To: <1187143925.32555.208.camel@localhost> (Joe Perches's message of
	"Tue, 14 Aug 2007 19:12:05 -0700")
Message-ID: <7vlkcdjrmu.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> Yes please.

Huh?

> Rene Herman had an idea about using some git
> metadata that might be useful.  The completely
> external data approach suggested by Al Viro 
> might be OK too in that it wouldn't tie listeners
> to git requiring more content in git metadata.

The reason I found Linus's suggestion desirable is because it
fundamentally does not require git to track any metadata.  If
the commits are in git, then his script would let you gather the
data, but otherwise you should be able to do the same by
grepping patches.  Obviously you would need to filter by paths,
looking at the diffstat, but the approach does _not_ tie users
to git.


