Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbZJCQNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbZJCQNo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 12:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZJCQNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 12:13:43 -0400
Received: from thunk.org ([69.25.196.29]:41094 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbZJCQNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 12:13:43 -0400
To: Jason Wessel <jason.wessel@windriver.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
cc: linux-kernel@vger.kernel.org
Subject: Hints about using the prototype kms/kdb/kgdb integration?
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Mu7EC-0007g8-Jk@closure.thunk.org>
Date: Sat, 03 Oct 2009 12:13:00 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jason, Jesse,

I was very much interested in using the kgdb/kdb integration that you
had demo'ed at the Plumber's Conference.   I know that this stuff is
still under development, so the documentation is rather scant.

According to http://kgdb.wiki.kernel.org, the demo at Plumber's
Conference used "kdb_prototype8 from the kgdb git repository".
Unfortunately, I couldn't find kdb_prototype8; I did find
kdb_prototype7, and a newer branch labelled "for_jesse".  The two
branches seemed largely identical in terms of the intent of the patches,
and for_jesse seemed more recent, so I used the latter.

It looked like the magic to get things working was:

   echo kms,kbd > /sys/module/kgdboc/parameters/kgdboc

However, I wasn't able to make kms work.  In fact, looking at the
sources, it's not clear that it would work at all, since
kgdboc_pre_exp_handler() requires that dbg_kms_console_core be set, and
the only thing which sets it is dbg_kms_console_ops_register() --- and I
couldn't find anything that actually calls
dbg_kms_console_ops_register().

Am I missing something?   Is there a branch that I should be using
instead of kdb_prototype7 or for_jesse?

Thanks!!

						- Ted
