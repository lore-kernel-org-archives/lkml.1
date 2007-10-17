Return-Path: <linux-kernel-owner+w=401wt.eu-S936058AbXJQCE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936058AbXJQCE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbXJQCEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:04:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48729 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017AbXJQCEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:04:50 -0400
Date: Wed, 17 Oct 2007 03:04:45 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] missing include in mmc
Message-ID: <20071017020445.GG8181@ftp.linux.org.uk>
References: <20071017000907.GF8181@ftp.linux.org.uk> <20071017002551.3577B23B309@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017002551.3577B23B309@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 05:25:51PM -0700, David Brownell wrote:
> > From viro@ftp.linux.org.uk  Tue Oct 16 17:18:43 2007
> > Date: Wed, 17 Oct 2007 01:09:07 +0100
> > From: Al Viro <viro@ftp.linux.org.uk>
> > To: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
> > Subject: [PATCH] missing include in mmc
> >
> > AFAICS, fallout from repacing include of blkdev.h with include of bio.h.
> 
> Out of curiousity, which architecture(s) need this?

Umm...   IIRC, m32r had been the first build to step into that, at which point
the missing include had been added; the rest had reached that point later, so
I'm not sure which ones would trigger the same crap.  Not hard to test,
though...

Aha.  m68k as well.
