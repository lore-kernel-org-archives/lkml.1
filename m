Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbYB0EzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbYB0EzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 23:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYB0Eyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 23:54:54 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50409 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbYB0Eyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 23:54:52 -0500
Date: Wed, 27 Feb 2008 13:45:18 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] page reclaim throttle take2
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <47C4E6CD.6090401@linux.vnet.ibm.com>
References: <20080227131939.4244.KOSAKI.MOTOHIRO@jp.fujitsu.com> <47C4E6CD.6090401@linux.vnet.ibm.com>
Message-Id: <20080227133850.4249.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> One more thing, I would request you to add default heuristics (number of
> reclaimers), based on the number of cpus in the system. Letting people tuning it
> is fine, but defaults should be related to number of cpus, nodes and zones on
> the system. Zones can be reaped in parallel per node and cpus allow threads to
> run in parallel. So please use that to come up with good defaults, instead of a
> number like "3".

I don't think so.
all modern many cpu machine stand on NUMA.
it mean following,
 - if cpu increases, then zone increases, too.

if default value increase by #cpus, lock contension dramatically increase
on large numa.

Have I overlooked anything?


and, (but) i afraid to 3 is too small value.
if you have another test result on large machine, please show me.

- kosaki


