Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbXIUJsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbXIUJsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbXIUJsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:48:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47284 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbXIUJr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:47:59 -0400
Date: Fri, 21 Sep 2007 11:45:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: nigel@suspend2.net, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Message-ID: <20070921094512.GA20149@elf.ucw.cz>
References: <1190266447.21818.17.camel@caritas-dev.intel.com> <200709211225.25874.nigel@nigel.suspend2.net> <1190342757.21818.75.camel@caritas-dev.intel.com> <200709211259.00195.nigel@nigel.suspend2.net> <m1r6ksiq27.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r6ksiq27.fsf@ebiederm.dsl.xmission.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> >
> > Sounds doable, as long as you can cope with long command lines (which 
> > shouldn't be a biggie). (If you've got a swapfile or parts of a swap 
> > partition already in use, it can be quite fragmented).
> 
> Hmm.  This is an interesting problem.  Sharing a swap file or a swap
> partition with the actual swap of user space pages does seem to be
> a limitation of this approach.
> 
> Although the fact that it is simple to write to a separate file may
> be a reasonable compensation.

I'm not sure how you'd write it to a separate file. Notice that kjump
kernel may not mount journalling filesystems, not even
read-only. (Ext3 replays journal in that case). You could pass block
numbers from the original kernel...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
