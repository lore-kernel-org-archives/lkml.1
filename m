Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbXGCGUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbXGCGUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 02:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbXGCGUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 02:20:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbXGCGUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 02:20:32 -0400
Date: Tue, 3 Jul 2007 02:20:20 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Message-ID: <20070703062020.GA5433@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org
References: <20070626230756.519733902@suse.de> <20070626165202.bfe8e6df.akpm@linux-foundation.org> <20070627022403.GB14656@suse.de> <20070626194700.5b0ff477.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626194700.5b0ff477.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 07:47:00PM -0700, Andrew Morton wrote:

 > I suspect that we're at the stage of having to decide between
 > 
 > a) set aside the technical issues and grudgingly merge this stuff as a
 >    service to Suse and to their users (both of which entities are very
 >    important to us) and leave it all as an object lesson in
 >    how-not-to-develop-kernel-features.
 > 
 >    Minimisation of the impact on the rest of the kernel is of course
 >    very important here.
 > 
 > versus
 > 
 > b) leave it out and require that Suse wear the permanent cost and
 >    quality impact of maintaining it out-of-tree.  It will still be an
 >    object lesson in how-not-to-develop-kernel-features.

How is this different from Red Hat wearing the permanent cost of
carrying Execshield or other vetoed-by-upstream features ?

Given the choice, I'd ship a kernel for Fedora with nothing added
that isn't upstream, but we have something of a legacy from our
dumber days. (Though we've managed to drop lots of the more invasive
stuff over time thankfully.. 4g4g for eg).

 > Sigh.  Please don't put us in this position again.  Get stuff upstream
 > before shipping it to customers, OK?  It ain't rocket science.

Indeed.  The idea of granting exceptions to our usual acceptance
criteria just because "some distro shipped it" strikes me as wrong
on so many levels, regardless of its technical flaws.

And this isn't just because this is a patch from a competitor,
I'd expect the exact same criteria to be applied if I tried
to ram execshield etc down everyones throats.

	Dave

-- 
http://www.codemonkey.org.uk
