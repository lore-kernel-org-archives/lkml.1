Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbYEPL55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbYEPL55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 07:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbYEPL5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 07:57:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47216 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbYEPL5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 07:57:44 -0400
Date: Fri, 16 May 2008 13:58:33 +0200
From: Pavel Machek <pavel@suse.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec
	multi-stage load
Message-ID: <20080516115833.GB22264@elf.ucw.cz>
References: <1210574441.30365.8.camel@caritas-dev.intel.com> <20080513053408.GA5870@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513053408.GA5870@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > During loading, a hash table mapped from destination page to source
> > page is used instead of original linear mapping
> > implementation. Because the hibernated image may be very large (up to
> > near the size of physical memory), it is very time-consuming to search
> > a source page given the destination page, which is used to check
> > whether an newly allocated page is in the range of allocated
> > destination pages.
> 
> This seems to be an optimization of kexec so that it becomes efficient
> in loading large images (containing large number of segments). Probably
> this can be a separate patch.
> 
> IMHO, we can just first write a minimal patch where one can just switch
> between kernels. Once that patch is upstream, we can enhance

Yes, please.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
