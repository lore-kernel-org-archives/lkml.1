Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbYGDQV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbYGDQV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYGDQVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:21:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:55619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbYGDQVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:21:43 -0400
Date: Fri, 4 Jul 2008 09:12:00 -0700
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <htejun@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 12/15] driver core: Implement tagged directory support
	for device classes.
Message-ID: <20080704161200.GA1440@suse.de>
References: <m18wwiihbn.fsf_-_@frodo.ebiederm.org> <m14p76ih9a.fsf_-_@frodo.ebiederm.org> <m1zloyh2mb.fsf_-_@frodo.ebiederm.org> <m1vdzmh2jr.fsf_-_@frodo.ebiederm.org> <m1r6aah2hh.fsf_-_@frodo.ebiederm.org> <m1mykyh2fu.fsf_-_@frodo.ebiederm.org> <m1hcb6h2d2.fsf_-_@frodo.ebiederm.org> <486DD650.3000804@gmail.com> <m1tzf593ny.fsf@frodo.ebiederm.org> <486E2C3B.6020603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486E2C3B.6020603@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 10:57:15PM +0900, Tejun Heo wrote:
> Hello, Eric.
> 
> Eric W. Biederman wrote:
> > Thank you for your opinion.
> > 
> > Incremental patches to make things more beautiful are welcome.
> > 
> > Please remember we are not building lisp.  The goal is code that works today.
> > 
> > Since we are not talking about correctness of the code.  Since we are not
> > talking about interfaces with user space.  Since we are talking something
> > that is currently about 100 lines of code, and so will be easy to change
> > even after it is merged.   I don't understand how discussing this further
> > is useful.  Especially when I get a NAK  based on the feel that the code
> > is ugly.
> 
> I'm sorry if I gave you the impression of being draconian.  Explanations
> below.
> 
> > As for your main objection.  Adding a accessor method to an object versus
> > adding a data field that contain the same thing.  The two are effectively
> > identical.  With the practical difference in my eyes that an accessor method
> > prevents data duplication which reduces maintenance and reduces skew problems,
> > and it keeps the size of struct kobject small.  Since you think methods are
> > horrible I must respectfully disagree with you.
> 
> Yeah, it seems we should agree to disagree here.  I think using callback
> for static values is a really bad idea.  It obfuscates the code and
> opens up a big hole for awful misuses.  Greg, what do you think?

Sorry, Greg is walking out the door in 30 minutes for a much needed week
long vacation and can't look into this right now :(

I'll be able to review it next weekend, sorry for the delay.

greg k-h
