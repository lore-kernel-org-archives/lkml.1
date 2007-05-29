Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbXE2Czv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbXE2Czv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 22:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbXE2Czo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 22:55:44 -0400
Received: from thunk.org ([69.25.196.29]:50473 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbXE2Czo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 22:55:44 -0400
Date: Mon, 28 May 2007 22:55:34 -0400
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       ext3-users@redhat.com
Subject: Re: fs periodic check (was Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted)
Message-ID: <20070529025534.GD24003@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
	Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
	ext3-users@redhat.com
References: <20070518090604.GA10841@ribosome.natur.cuni.cz> <9a8748490705180720u3baf9785l910581a2a76a6eb@mail.gmail.com> <20070518143529.GB14611@ribosome.natur.cuni.cz> <20070518215731.GB10655@thunk.org> <20070520195526.GA5235@ucw.cz> <20070522180158.GA4668@thunk.org> <20070524173911.GA4541@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524173911.GA4541@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 05:39:11PM +0000, Pavel Machek wrote:
> Right. Could we get more helpful message here? 'Filesystem check on
> next boot on AC power'? 

So "(check deferred; on battery)" wasn't explicit enough?  I guess I
assumed that users would understand that the opposite of "on battery"
was "on AC power".  I guess I could say "(check defferred 'til on AC
power)" if people think it would be clearer.

> Or maybe keep counting, and when we reach 2x mount-count-limit,
> force a fsck, battery power or not?

We do that already.  It's just tough to make that all fit on an 80
status message.  :-)

						- Ted
