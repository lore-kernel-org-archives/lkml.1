Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbYEPMRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbYEPMRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 08:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbYEPMRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 08:17:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54179 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYEPMRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 08:17:41 -0400
Date: Fri, 16 May 2008 14:18:36 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Huang, Ying" <ying.huang@intel.com>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080516121836.GE22264@elf.ucw.cz>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <m13aok1pt1.fsf@frodo.ebiederm.org> <200805150155.33787.rjw@sisk.pl> <m163tfi5sq.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m163tfi5sq.fsf@frodo.ebiederm.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-05-15 15:03:17, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > Well, it looks like we do similar things concurrently.  Please have a look 
> > here: http://kerneltrap.org/Linux/Separating_Suspend_and_Hibernation
> 
> Yes.  Part of the reason I wanted to separate these two conversations
> I knew something was going on.
> 
> > Similar patches are in the Greg's tree already.
> 
> Taking a look.
> 
> I just can't get past the fact in that the only reason hibernation can
> not use the widely implemented and tested probe/remove is because of
> filesystems on block devices, and that you are proposing to add 4
> methods for each and every driver to handle that case, when they
> don't need ANYTHING!
> 
> I wonder how hard teaching the upper layers to deal with
> hotplug/remove is?

It looked _too_ hard when I was looking... at least if we are thinking
off "keep the filesystem mounted over unplug-replug".

Or do you have something else in mind?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
