Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbYBVXek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbYBVXek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 18:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYBVXeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 18:34:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282AbYBVXea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 18:34:30 -0500
Date: Fri, 22 Feb 2008 18:34:07 -0500
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, arjan@infradead.org,
       gregkh@suse.de, stable@kernel.org, stable-commits@vger.kernel.org
Subject: Re: [stable] patch
	kbuild-allow-fstack-protector-to-take-effect.patch added to
	2.6.24-stable tree
Message-ID: <20080222233407.GB20829@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	linux-kernel@vger.kernel.org, sam@ravnborg.org, arjan@infradead.org,
	gregkh@suse.de, stable@kernel.org, stable-commits@vger.kernel.org
References: <200802190005.m1J05SKP017015@hera.kernel.org> <20080222230103.CC4EF14540D0@imap.suse.de> <20080222230604.GA20829@redhat.com> <20080222231808.GA30669@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222231808.GA30669@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 03:18:08PM -0800, Greg Kroah-Hartman wrote:
 > On Fri, Feb 22, 2008 at 06:06:04PM -0500, Dave Jones wrote:
 > > On Fri, Feb 22, 2008 at 03:00:58PM -0800, gregkh@suse.de wrote:
 > >  > 
 > >  > This is a note to let you know that we have just queued up the patch titled
 > >  > 
 > >  >      Subject: kbuild: allow -fstack-protector to take effect
 > >  > 
 > >  > to the 2.6.24-stable tree.  Its filename is
 > >  > 
 > >  >      kbuild-allow-fstack-protector-to-take-effect.patch
 > >  > 
 > >  > A git repo of this tree can be found at 
 > >  >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
 > > 
 > > Is this wise given this thread..  http://lkml.org/lkml/2008/2/22/101    ?
 > > 
 > > At least until the problem is understood, not enabling this seems like
 > > a better option for -stable
 > 
 > I thought that thread was for the much larger patches, not just this
 > Makefile change.

At the least we'll likely want to also pick up the other stack protector fixes
that went into .25rc if we turn it on in .24
 
	Dave

-- 
http://www.codemonkey.org.uk
