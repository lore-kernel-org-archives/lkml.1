Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZJGVbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZJGVbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbZJGVbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:31:08 -0400
Received: from khc.piap.pl ([195.187.100.11]:57595 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbZJGVbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:31:07 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Daniel Walker <dwalker@fifo99.com>
Cc: rostedt@goodmis.org, Andy Whitcroft <apw@canonical.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	<1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	<1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	<4AB86ED1.1040200@cn.fujitsu.com> <20090930152708.GD2957@shadowen.org>
	<1254406711.18167.88.camel@desktop>
	<m33a5ww8kn.fsf@intrepid.localdomain>
	<1254887534.18167.253.camel@desktop>
	<m3hbubv779.fsf@intrepid.localdomain>
	<1254925617.18167.262.camel@desktop>
	<1254928114.1696.164.camel@gandalf.stny.rr.com>
	<1254929907.18167.301.camel@desktop>
Date: Wed, 07 Oct 2009 23:30:27 +0200
In-Reply-To: <1254929907.18167.301.camel@desktop> (Daniel Walker's message of
	"Wed, 07 Oct 2009 08:38:27 -0700")
Message-ID: <m3my42uc24.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker <dwalker@fifo99.com> writes:

> Just relax the submission rules so that checkpatch is basically an
> optional part of the submission process. Adding that you don't actually
> need to run it, you don't need a good reason not to follow the rules
> etc.. Or expand on it to fully explain what you think the deal is or
> should be.

Oh come on... The SubmittingPatches is a HOWTO-style document for people
who want to get their patches merged. Obviously a common sense dictates
you need a good reason to ignore this or that. "Looks better" and
"I find it easier to work with" are good reasons since this is source
code, for humans to work with.

BTW, the file says:

"Check your patches with the patch style checker prior to submission
(scripts/checkpatch.pl).  The style checker should be viewed as
a guide not as the final word.  If your code looks better with
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^
a violation then its probably best left alone.

The checker reports at three levels:
 - ERROR: things that are very likely to be wrong
                               ^^^^^^
 - WARNING: things requiring careful review
 - CHECK: things requiring thought"

Only "very likely".

WRT tabs vs spaces, I wonder if using only spaces would be a better
idea. Theoretically using tabs for syntactic indentation only is better,
but the tools (editors) aren't up to the task yet.
-- 
Krzysztof Halasa
