Return-Path: <linux-kernel-owner+w=401wt.eu-S1762634AbYDSWGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762634AbYDSWGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 18:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757379AbYDSWFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 18:05:53 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:15848 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757359AbYDSWFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 18:05:52 -0400
From: Frans Pop <elendil@planet.nl>
To: Richard Jonsson <richie@coderworld.net>
Subject: Re: [rc8] Regression: key repeats and skips in music during compilation
Date: Sun, 20 Apr 2008 00:05:48 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <200804041222.35025.elendil@planet.nl> <48009D04.3000509@coderworld.net> <480A64B9.2080307@coderworld.net>
In-Reply-To: <480A64B9.2080307@coderworld.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804200005.50236.elendil@planet.nl>
X-OriginalArrivalTime: 19 Apr 2008 22:05:50.0533 (UTC) FILETIME=[874D8750:01C8A269]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 April 2008, Richard Jonsson wrote:
> Bisecting this bug is very inefficient, but I've managed to narrow it
> down a bit more.

Hello Richard,

The bug was already traced by me to "sched: fix fair sleepers" (which you 
list as well), and this was reverted just before the final 2.6.25 release.

Can you confirm that the issue is fixed for you as well with v2.6.25?

Unfortunately most of the communication about this was done by private 
mails, although I did update the bugzilla entry and replied to the
"regressions" mails from Rafael. It's a pity if this has caused you 
unnecessary work.

Note that Ingo has just resubmitted the (probably same) patch for 2.6.26 
[1], so we're not done with this yet.

Cheers,
FJP

[1] http://lkml.org/lkml/2008/4/19/166 (see also my reply)
