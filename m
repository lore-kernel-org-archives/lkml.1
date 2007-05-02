Return-Path: <linux-kernel-owner+w=401wt.eu-S2993168AbXEBWBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993168AbXEBWBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993169AbXEBWBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:01:47 -0400
Received: from THUNK.ORG ([69.25.196.29]:40446 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993168AbXEBWBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:01:45 -0400
Date: Wed, 2 May 2007 18:01:38 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jeremy Allison <jra@samba.org>, Andrew Morton <akpm@linux-foundation.org>,
       "Cabot, Mason B" <mason.b.cabot@intel.com>,
       linux-kernel@vger.kernel.org, tridge@samba.com
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070502220138.GI19442@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Garzik <jeff@garzik.org>, Jeremy Allison <jra@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Cabot, Mason B" <mason.b.cabot@intel.com>,
	linux-kernel@vger.kernel.org, tridge@samba.com
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com> <20070501142325.09c294bd.akpm@linux-foundation.org> <20070502161638.GB19442@thunk.org> <20070502180810.GC28726@jeremy-laptop> <20070502193456.GE19442@thunk.org> <4638F6DF.7020400@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4638F6DF.7020400@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 04:38:55PM -0400, Jeff Garzik wrote:
> >	I think we mostly have consensus on a calling convention which
> >all of the architectures (s390, power, arm, ia64, etc.); of course
> >then we will need to get glibc to support the new system call.
> 
> glibc has had support for a while, in emulated form: 
> http://www.uwsg.iu.edu/hypermail/linux/kernel/0004.1/1153.html
> 
> So when kernel support arrives, it should be easy and (hopefully) 
> seamless to plug in the new syscall.

Yep.  Although unfortunately given where we are in distro release
cycles (and I'm not sure where glibc is in its release cycle), it'll
probably be a year or so before most users will see the benefits.  So
it would be nice if we can get samba using the fallocate() support
now, in the hopes that we can get all of the pieces aligned in time
for the next major enterprise distro releases.

						- Ted
