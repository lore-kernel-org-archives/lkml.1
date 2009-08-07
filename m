Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZHGRoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZHGRoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbZHGRoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:44:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60993 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbZHGRoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:44:37 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Eric Paris <eparis@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a.p.zijlstra@chello.nl, tvrtko.ursulin@sophos.com,
       douglas.leeder@sophos.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, malware-list@dmesg.printk.net,
       Valdis.Kletnieks@vt.edu, greg@kroah.com, jcm@redhat.com, tytso@mit.edu,
       arjan@infradead.org, david@lang.hm, jengelh@medozas.de,
       aviro@redhat.com, mrkafk@gmail.com, alexl@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in
In-Reply-To: <E1MZSQZ-0002as-FA@pomaz-ex.szeredi.hu>
References: <1248466429.3567.82.camel@localhost> <4A7AAE89.20205@sophos.com>
	 <1249554548.32113.137.camel@twins>
	 <200908061159.45550.tvrtko.ursulin@sophos.com>
	 <1249557831.32113.234.camel@twins>
	 <1249582695.20644.35.camel@dhcp231-106.rdu.redhat.com>
	 <E1MZSQZ-0002as-FA@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 13:43:10 -0400
Message-Id: <1249666990.2694.6.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 18:36 +0200, Miklos Szeredi wrote:
> On Thu, 06 Aug 2009, Eric Paris wrote:
> > just work.  The whole reason for the timeout is because I don't trust
> > userspace not to get it wrong and I'd rather not lose my box because of
> > it.
> 
> IMO this has nothing to do with userspace(*) and everything to do with
> complexity.  Virus scanning is complex and any such code, whether
> runing in userspace or not, can easily screw up and freeze the system.

I agree, 'userspace' was not the best term.  Let me rephrase:

"The whole reason for the timeout is because I don't trust anything not
to get it wrong and I'd rather not lose my box because of it."

> The way to solve that is not to implement hacks on the kernel
> interface, but rather by separating the complex parts and implementing
> a simple watchdog layer on top of that, that makes sure things don't
> go wrong.

So you would argue that every fanotify listener implement their own
watchdog layer that may or may not be correct rather than do a single
watchdog layer for everyone?  And that's better?

-Eric

