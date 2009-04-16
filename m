Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbZDPQ4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbZDPQ4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758803AbZDPQzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:55:47 -0400
Received: from thunk.org ([69.25.196.29]:41557 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758155AbZDPQzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:55:46 -0400
Date: Thu, 16 Apr 2009 12:55:34 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Price <andy@andrewprice.me.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: BUG: using rootfstype=ext4 causes oops
Message-ID: <20090416165534.GO21586@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Price <andy@andrewprice.me.uk>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20090415205926.GA28246@sucs.org> <20090416041945.GK21586@mit.edu> <20090416104758.GA433@sucs.org> <20090416145357.GM21586@mit.edu> <20090416163835.GB433@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416163835.GB433@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 05:38:36PM +0100, Andrew Price wrote:
> On Thu, Apr 16, 2009 at 10:53:57AM -0400, Theodore Tso wrote:
> > OK, can you confirm that you tried using ext4 with either 2.6.29 or
> > 2.6.28, and it was working previously?  That would make it a
> > regression which Rafael would track.
> 
> I've tested this with a local GFS2 mount (which uses barriers too) and
> the same bug occurs. Apologies for making it seem like an ext4 bug.  I'm
> currently waiting for a kernel to build with Bartlomiej's patch so we'll
> see how that goes.

No, no, that's fine.  That sort of thing we get all the time; it's
part of trying to find the root cause of the bug.  What I was more
interested in was trying to figure out when (at which kernel version)
the bug had introduced; if it's a recent regression then Rafael would
be interested in tracking it as such.

> Further up in that file in the last paragraph of the 'Quick usage
> instructions' it says:
> 
> [...]
> '-o barriers=[0|1]' mount option for both ext3 and ext4 filesystems
> [...]
> 

OK, got it.  Thanks.   I'll queue up a patch to fix that up.

    	     	       	    	       - Ted
