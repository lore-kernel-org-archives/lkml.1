Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYE2BId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYE2BId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 21:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYE2BIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 21:08:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbYE2BIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 21:08:23 -0400
Date: Wed, 28 May 2008 21:00:55 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Message-ID: <20080529010055.GA31952@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	ksummit-2008-discuss@lists.linux-foundation.org,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20080528225136.GA29014@kroah.com> <1FE6DD409037234FAB833C420AA843EC016FFF69@orsmsx424.amr.corp.intel.com> <20080529003657.GA17505@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529003657.GA17505@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 05:36:57PM -0700, Greg Kroah-Hartman wrote:
 > On Wed, May 28, 2008 at 04:23:52PM -0700, Luck, Tony wrote:
 > > > My raw numbers show that the number of individual kernel contributors
 > > > continues to increase with every release, so this might not be as much
 > > > of a problem as it's made out to be.
 > > 
 > > That depends on whether we are gradually adding to the pool
 > > of developers, or seeing an increasing stream of newcomers
 > > who supply a patch or two before disappearing again.
 > > 
 > > If you look at the list of contributors some old release for
 > > which we have good data (say 2.6.16).  How many of those people
 > > contributed to each of the following releases? Does the
 > > decay curve look steeper or more gentle if you start from
 > > a more recent release?
 > 
 > I don't know, I haven't tracked the people individually that way, only
 > looked at the basic numbers of developers per release.

Are you just doing something like
 git log v2.6.16..v2.6.17 | grep ^Author: | sort -u| wc -l  

or do you have some script that maps addresses to people ?
One person may appear once in 2.6.20, and then a half dozen times
in 2.6.21 if they use multiple email addresses for example.
(Also, typos, and people using full hostnames in their sign-off's
 instead of email addresses skew this somewhat).

I'm guessing the latter, due to the graph thing you did. Pointers?

	Dave

-- 
http://www.codemonkey.org.uk
