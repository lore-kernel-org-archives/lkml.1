Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab0BLVyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:54:54 -0500
Received: from kroah.org ([198.145.64.141]:48431 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab0BLVyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:54:52 -0500
Date: Fri, 12 Feb 2010 13:54:03 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100212215403.GA29469@kroah.com>
References: <4B744E13.8040004@kernel.org>
 <20100212150137.648dca7c@hyperion.delvare>
 <4B75A5FE.8020408@zytor.com>
 <20100212202534.GH11239@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100212202534.GH11239@parisc-linux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 01:25:34PM -0700, Matthew Wilcox wrote:
> On Fri, Feb 12, 2010 at 11:03:26AM -0800, H. Peter Anvin wrote:
> > > 3* Create a new subdirectory for every 2.6.x kernel, and move all the
> > > related files there. This would shrink the main index drastically, and
> > > each subdirectory would have a reasonable size (except maybe 2.6.16 and
> > > 2.6.27.) Oddly enough this has been done for the files under testing/
> > > already, so I am curious why we don't do it for the release files (and
> > > the testing/incr/ files, while we're at it.)
> > 
> > Well, part of the reason why is that we're functionally "stuck" on 2.6;
> > a prefix which really has lost all meaning.
> > 
> > It might open up the question if we shouldn't just do a Solaris and drop
> > the leading 2 (so the next kernel would be 6.33) or call the kernel
> > after that 3.0 instead of 2.6.34, and then 3.1 instead of 2.6.35.
> 
> Damn, we forgot to have that fight at Kernel Summit last year.

No one wanted to take it on :(

> I'm in favour of the 3.0 / 3.1 / 3.2 with stable@ being responsible for
> 3.0.1, 3.0.2, 3.1.1, etc.

I'm in favor of almost _anything_ new, the current numbering scheme
drives me crazy, but then, I'm the one having to deal with it more than
anyone these days...

thanks,

greg k-h
