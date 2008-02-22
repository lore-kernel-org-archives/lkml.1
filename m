Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbYBVX7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbYBVX7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 18:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbYBVX7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 18:59:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760508AbYBVX7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 18:59:40 -0500
Date: Fri, 22 Feb 2008 18:59:14 -0500
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, arjan@infradead.org,
       gregkh@suse.de, stable@kernel.org, stable-commits@vger.kernel.org
Subject: Re: [stable] patch
	kbuild-allow-fstack-protector-to-take-effect.patch added to
	2.6.24-stable tree
Message-ID: <20080222235914.GC20829@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	linux-kernel@vger.kernel.org, sam@ravnborg.org, arjan@infradead.org,
	gregkh@suse.de, stable@kernel.org, stable-commits@vger.kernel.org
References: <200802190005.m1J05SKP017015@hera.kernel.org> <20080222230103.CC4EF14540D0@imap.suse.de> <20080222230604.GA20829@redhat.com> <20080222231808.GA30669@kroah.com> <20080222233407.GB20829@redhat.com> <20080222234216.GA25809@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222234216.GA25809@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 03:42:16PM -0800, Greg Kroah-Hartman wrote:

 > >  > I thought that thread was for the much larger patches, not just this
 > >  > Makefile change.
 > > 
 > > At the least we'll likely want to also pick up the other stack protector fixes
 > > that went into .25rc if we turn it on in .24
 > 
 > Hm, that sounds like a new feature :)
 > 
 > I thought the makefile change was just a bugfix in the broken makefile.

Well, it is. But it'll cause it to enable something that has been broken for a while.
FWIW, I think having the stack protector reenabled in -stable is a worthwhile goal,
but only once it's stabilised for a while in the development tree.

My fear by just reenabling this for -stable is that when distros push out updates
based on the latest -stable, we'll see more systems like James' problematic system.

	Dave

-- 
http://www.codemonkey.org.uk
