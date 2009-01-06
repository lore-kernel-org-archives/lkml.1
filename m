Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZAFSEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZAFSEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbZAFSET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:04:19 -0500
Received: from THUNK.ORG ([69.25.196.29]:40464 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZAFSES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:04:18 -0500
Date: Tue, 6 Jan 2009 13:04:14 -0500
From: Theodore Tso <tytso@mit.edu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Beulich <jbeulich@novell.com>, ccache@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090106180414.GB10903@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Sam Ravnborg <sam@ravnborg.org>, Jan Beulich <jbeulich@novell.com>,
	ccache@lists.samba.org, linux-kernel@vger.kernel.org
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <496386EF.76E4.0078.0@novell.com> <20090106173300.GA10903@mit.edu> <20090106174825.GA16365@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106174825.GA16365@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 06:48:25PM +0100, Sam Ravnborg wrote:
> 
> I'm all ears for inputs how to make them even a little more readable.
> We actually used several iteratiosn of Jan's patch just to improve
> readability in areas the patch touched.
> 
> I think at least half of the unreadability comes from the fact that
> people do not realise the steps needed to actually build the kernel.

Yeah, I thought about that a lot, but I couldn't come up with a
constructive suggestion.  The best I could come up with to have kbuild
generate a shell script helper or use a shell script helper to
actually build each .o file.  However, the speed hit probably makes
that unacceptable, although it would make it easier, I suspect, to use
that abstractionas part of making something which ccache or distcc
could use to cache (or distribute to a cluster) all of the steps
needed to build each object file.  Maybe a helper C program instead?

       	  	     	    	   	   - Ted

