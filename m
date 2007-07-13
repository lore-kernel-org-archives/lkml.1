Return-Path: <linux-kernel-owner+w=401wt.eu-S936197AbXGMOff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936197AbXGMOff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932191AbXGMOf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:35:26 -0400
Received: from alnrmhc14.comcast.net ([204.127.225.94]:62677 "EHLO
	alnrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760472AbXGMOfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:35:25 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: david@lang.hm
Cc: Joseph Fannin <jfannin@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Huang\, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: Hibernating To Swap Considered Harmful
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	<200707121453.49616.rjw@sisk.pl>
	<Pine.LNX.4.64.0707121150460.25614@asgard.lang.hm>
	<200707122134.29991.rjw@sisk.pl>
	<Pine.LNX.4.64.0707121953440.25614@asgard.lang.hm>
	<20070713054244.GA20082@nineveh.local>
	<Pine.LNX.4.64.0707122250170.25614@asgard.lang.hm>
	<20070713062039.GA29055@nineveh.local>
	<Pine.LNX.4.64.0707122319270.25614@asgard.lang.hm>
	<20070713071512.GB29055@nineveh.local>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Fri, 13 Jul 2007 10:35:22 -0400
In-Reply-To: <20070713071512.GB29055@nineveh.local> (Joseph Fannin's message
	of "Fri\, 13 Jul 2007 03\:15\:12 -0400")
Message-ID: <87odig1idx.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jfannin@gmail.com (Joseph Fannin) writes:

[snip]

> Intel Macs use GPT partition tables, which support a huge number
> of primary partitions, and so don't support secondary partitions.

> 32bit Windows does not support GPT, so PC-style MBR partition tables
> must also be used.  GPT was designed to coexist with MBR tools, so
> this mostly works, but you're limited to the union of supported
> features -- 4 primary partitions, no secondaries.

There is a very simple solution to this obscure problem: (if I
understand correctly, you want to dual boot Mac OS X and Linux (and
maybe also Windows?))

use LVM, thus allowing you to have as many volumes as you like in the
partition

-- 
Jeremy Maitin-Shepard
