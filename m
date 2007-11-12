Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbXKLPiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbXKLPiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbXKLPiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:38:15 -0500
Received: from mail.fieldses.org ([66.93.2.214]:49117 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbXKLPiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:38:14 -0500
Date: Mon, 12 Nov 2007 10:38:06 -0500
To: Benny Halevy <bhalevy@panasas.com>
Cc: James Courtier-Dutton <James@superbug.co.uk>,
       Xavier Bestel <xavier.bestel@free.fr>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Coding Style: indenting with tabs vs. spaces
Message-ID: <20071112153806.GA27855@fieldses.org>
References: <4732E6BA.8060001@panasas.com> <20071110120424.GA16067@DervishD> <1194697674.6176.1.camel@bip.parateam.prv> <20071110165017.GB16090@DervishD> <4736CA1D.9020507@superbug.co.uk> <47380B14.3010604@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47380B14.3010604@panasas.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 10:13:08AM +0200, Benny Halevy wrote:
> checkpatch allows to indent with any number of tabs and up to 7 spaces.
> This is consistent with Documentation/CodingStyle and therefore can be
> considered "correct".  However, forcing everybody to the same tab expansion
> setup is too limiting, especially when working in several environments
> at the same time where some of them may not be the linux kernel.
> 
> Using only spaces as DervishD suggested works around that using brute force
> by forcing the user to the author's preference which is legitimate but
> may not be the most productive way.
> 
> I think that my proposal of using tabs as logical indents only (as Xav put it)
> and spaces for decorative alignment provides the best of both worlds.
> One can expand the tabs to any number of spaces as one likes and then
> the trailing spaces will work on any editor setup as long as you use
> fixed-width font.  That's not considered "correct" as per checkpatch but
> works much better for me.

The tabs-for-indent, spaces-for-alignment policy been proposed before;
this:

	http://marc.info/?t=119251728100004&r=1&w=2

was only on the git mailing list, but we could probably dig up similar
discussions on lkml with some more work.

Speaking as someone who doesn't care, but doesn't see it as a
particularly interesting discussion, either....

--b.
