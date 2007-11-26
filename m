Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbXKZNsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbXKZNsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 08:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbXKZNs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 08:48:26 -0500
Received: from gherkin.frus.com ([192.158.254.49]:33731 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbXKZNsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 08:48:25 -0500
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
In-Reply-To: <20071124223835.ddd5f6e4.akpm@linux-foundation.org>
 "from Andrew Morton at Nov 24, 2007 10:38:35 pm"
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 26 Nov 2007 07:48:19 -0600 (CST)
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20071126134819.8FE56DBA2@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Could be something change in sysfs.  Please double-check the config
> options, make sure that something important didn't get disabled.
> 
> Failing that, it would be great if you could bisect this down to the
> offending commit.  http://www.kernel.org/doc/local/git-quick.html has help.

I was out of town last week, and will be out this week as well.  Won't be
able to do the bisection until next week at the earliest, but I have remote
access to the box if there's anything useful to be done that doesn't require
a reboot.  No logs available for the "no sd access" case: I'd have to rig up
something to record the console output during boot if that's needed.  Here's
hoping someone else is seeing this or can replicate it in the meantime.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
