Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZKCRAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZKCRAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZKCRAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:00:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbZKCRA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:00:29 -0500
Subject: Re: [-next regression] lockdep? tracing? BUG: unable to handle
 kernel paging request at
From: Eric Paris <eparis@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       zhaolei@cn.fujitsu.com, mingo@elte.hu, lizf@cn.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1257264170.26028.3340.camel@gandalf.stny.rr.com>
References: <1257263296.2891.97.camel@dhcp231-106.rdu.redhat.com>
	 <1257264170.26028.3340.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Nov 2009 12:00:17 -0500
Message-Id: <1257267617.2891.107.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 11:02 -0500, Steven Rostedt wrote:
> [ Added Peter Zijlstra ]
> 
> On Tue, 2009-11-03 at 10:48 -0500, Eric Paris wrote:
> > Linux-next from Oct 30 did not have this problem.  Linux next from
> > yesterday (and today) I always hit this on boot.
> 
> Could you also give the SHA1 of Linux-next, as well as the config you
> used.

False alarm, apparently this is due to a patch that I added.  Odd part
is, I don't touch anything even remotely close to this section of code.
I'm at a bit of a lose, but apply my patch, boom, revert, works.

I'll figure it out eventually I guess.

-Eric

