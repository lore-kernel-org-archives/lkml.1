Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbZABOF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbZABOF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 09:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZABOFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 09:05:14 -0500
Received: from thunk.org ([69.25.196.29]:49020 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbZABOFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 09:05:12 -0500
Date: Fri, 2 Jan 2009 09:04:09 -0500
From: Theodore Tso <tytso@mit.edu>
To: Rob Landley <rob@landley.net>
Cc: Christoph Hellwig <hch@infradead.org>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090102140409.GA4758@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Rob Landley <rob@landley.net>,
	Christoph Hellwig <hch@infradead.org>,
	Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
	linux-kernel@vger.kernel.org,
	Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901021026.37905.a.miskiewicz@gmail.com> <20090102094934.GB17841@infradead.org> <200901020656.32013.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901020656.32013.rob@landley.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 06:56:31AM -0600, Rob Landley wrote: 
> That said, how is bash _worse_ than perl?  (Where's the second
> implementation of perl?  Even Python had jython, but perl
> has... what?  The attempt to rebase on Parrot went down in
> flames...)

(1) bash implies POSIX extensions; perl is actually quite portable.

(2) There are distributions that install with perl by default but not
bash; they use dash for speed reasons.

Sounds like though modulo dealing with 64-bit arithmetic, your patches
are mostly dash/POSIX.2 comformant, so you're probably mostly good on
that front once you address the 32/64-bit issues.  I'd also suggest
explicitly add a reminder to the shell scripts' comments to avoid
bashisms for maximum portability, to remind developers in the future
who might try to change the shell scripts to watch out for portability
issues.

							- Ted

