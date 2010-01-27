Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265Ab0A0Aui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0A0Aui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033Ab0A0Aug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:50:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59320 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab0A0Auf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:50:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
Cc: kosaki.motohiro@jp.fujitsu.com, Roman Jarosz <kedgedev@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, A Rojas <nqn1976list@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
In-Reply-To: <89khjo$egh4fr@orsmga002.jf.intel.com>
References: <2f11576a1001260503o5f987512n3c39ae1c3caa43f3@mail.gmail.com> <89khjo$egh4fr@orsmga002.jf.intel.com>
Message-Id: <20100127091903.6AD5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 27 Jan 2010 09:50:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 26 Jan 2010 22:03:06 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Please consider to revert such commit at once. Lots people reported
> > the same issue.
> > I really hope to stop bug report storm.
> 
> Your CC did not reference the problem that you were discussing, nor that
> it is even easier to trigger an OOM without the shrinker. Memory
> exhaustion due to the excess usage of surfaces from userspace is not a new
> issuer. So what is the problem you have encountered and how does running
> the OOM killer earlier fix the issue of triggering the OOM killer?

Why do you bother easy googling?

example.

1) http://bugzilla.kernel.org/show_bug.cgi?id=14933
	Subject    : OOM killer unexpectedly called with kernel 2.6.32
	Submitter  : "A. Boulan" <arnaud.boulan@libertysurf.fr>
	Date       : 2009-12-24 23:42
	References : http://marc.info/?l=linux-kernel&m=126169821317492&w=4

2) http://bugzilla.kernel.org/show_bug.cgi?id=15015
	Subject: blank screen at random times in laptop when sitting idle
	From:    Jithin Emmanuel
	Date:    2010-01-09 16:48:23

	see comment #2

3) http://bugzilla.kernel.org/show_bug.cgi?id=15058
	From:   Michael Reinelt
	Date:   2010-01-14 16:39:51

4) Subject: Re: OOM kernel behaviour
   From: David John <davidjon@xenontk.org>
   Mon, 07 Dec 2009 11:04:24 +0530

5) This thread



