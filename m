Return-Path: <linux-kernel-owner+w=401wt.eu-S1764363AbXFAUit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764363AbXFAUit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762503AbXFAUim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:38:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57505 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762898AbXFAUil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:38:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Document the hotplug code is incompatible with x86 irq handling
Date: Fri, 1 Jun 2007 22:44:38 +0200
User-Agent: KMail/1.9.5
Cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Ingo Molnar <mingo@elte.hu>
References: <fa.tUMR7tAB+jMgtfyl/LJ7U9QMgBs@ifi.uio.no> <200706012206.15794.rjw@sisk.pl> <m14plrzadk.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14plrzadk.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706012244.39019.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Removed the Zwane's address from the CC list, because I get rejects from it]

On Friday, 1 June 2007 22:29, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > Very well, but could you _please_ give us some time to do this?
> >
> > We know of the problem now and will work to fix it, but it's not _that_ easy.
> >
> > In fact, we also rely on the CPU hotplug's code that takes tasks away from the
> > offlined CPUs (and does the opposite with respect to the onlined CPUs), so
> > we just can't get rid of the CPU hotplug _right_ _now_.
> 
> Sure.  My primary point was to document this, and get things moving if
> possible to fix it.  This patch is 2.6.23 at the earliest, so there is
> some time to work on it even on the most optimistic merge schedule.
> 
> I just don't want to be complacent and let this problem sit undetected
> in back corner any more.

So, can you advise what we can do to get the "nonboot" CPUs out of the picture
during a suspend/hibernation?

Greetings,
Rafael
 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
