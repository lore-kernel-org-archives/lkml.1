Return-Path: <linux-kernel-owner+w=401wt.eu-S1765705AbXFRUuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765705AbXFRUuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762633AbXFRUuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:50:23 -0400
Received: from mail.fieldses.org ([66.93.2.214]:55703 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763318AbXFRUuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:50:22 -0400
Date: Mon, 18 Jun 2007 16:50:00 -0400
To: Theodore Tso <tytso@mit.edu>, Jeremy Allison <jra@samba.org>,
       alan <alan@clueserver.org>,
       =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070618205000.GL2334@fieldses.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int> <20070618140143.GD30244@thunk.org> <Pine.LNX.4.64.0706180907580.22137@blackbox.fnordora.org> <20070618172955.GB24189@thunk.org> <20070618173342.GB1152@samba1> <20070618203033.GD24189@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618203033.GD24189@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 04:30:33PM -0400, Theodore Tso wrote:
> Well, I just want to make sure people know that Samba isn't asking for
> it any more, and I don't know of any current requests outstanding from
> any of the userspace projects.  So there's no one we need to ship off
> to the re-education camps about why filesystem fork/streams are a bad
> idea.  :-)

NFSv4 also has support for "named attributes"/forks/streams.  As far as
I can recall, though, the only requests I've seen for it (aside from
people just running through NFSv4 feature checklists) have been from
people that really just wanted extended attributes.

And it'd probably actually be pretty easy to extend the v4 protocol to
support extended attributes if someone wanted to.

--b.
