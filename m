Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbZISWDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbZISWDA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 18:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZISWC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 18:02:59 -0400
Received: from gate.in-addr.de ([212.8.193.158]:47215 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752936AbZISWC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 18:02:58 -0400
Date: Sun, 20 Sep 2009 00:02:32 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com
Cc: neilb@suse.de, hch@infradead.org, James.Bottomley@suse.de,
       lars.ellenberg@linbit.com, linux-kernel@vger.kernel.org,
       drbd-dev@lists.linbit.com, akpm@linux-foundation.org,
       bart.vanassche@gmail.com, davej@redhat.com, gregkh@suse.de,
       kosaki.motohiro@jp.fujitsu.com, kyle@moffetthome.net,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org
Subject: Re: [GIT PULL] DRBD for 2.6.32
Message-ID: <20090919220232.GB31849@suse.de>
References: <20090917161108.GA3361@infradead.org> <19122.65335.126937.476968@notabene.brown> <20090918200803.GM23126@kernel.dk> <20090919141334N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090919141334N.fujita.tomonori@lab.ntt.co.jp>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-09-19T14:14:30, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> I guess that Christoph is worry about adding another user interface
> for kinda device management; once we merge this, we can't fix it (for
> the raid unification).

Why can't it be fixed?

Either

a) there's going to be a transition period during which the "old"
interface is supported but depreciated and scheduled to be removed (all
driving the new unified same back-end),

or b) there's going to be a new kernel which requires new user-space
tools sharp.

In either case, dm/md are affected by this, so a third interface doesn't
really make much difference. The refactoring needs to happen in the
back-end anyway, and that actually becomes easier when all concurrent
implementations are present and can be reworked at the same time.

> BTW, DM already has something like drbd? I thought that there is a
> talk about that new target at LinuxCon.

dm-replicator is nowhere near as usable as DRBD, and not upstream yet
either. (Further, it's another independent implementation, pursued
instead of unifying any of the existing ones or helping to merge drbd -
don't get me started on my thoughts of that.)


Regards,
    Lars

-- 
Architect Storage/HA, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

