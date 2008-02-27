Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYB0Fgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYB0Fgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 00:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYB0Fgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 00:36:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52378 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYB0Fgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 00:36:39 -0500
Date: Wed, 27 Feb 2008 14:33:57 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [RFC][PATCH] page reclaim throttle take2
Cc: kosaki.motohiro@jp.fujitsu.com, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.DEB.1.00.0802262115270.1799@chino.kir.corp.google.com>
References: <47C4EF2D.90508@linux.vnet.ibm.com> <alpine.DEB.1.00.0802262115270.1799@chino.kir.corp.google.com>
Message-Id: <20080227143301.4252.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> I disagree, the config option is indeed static but so is the NUMA topology 
> of the machine.  It represents the maximum number of page reclaim threads 
> that should be allowed for that specific topology; a maximum should not 
> need to be redefined with yet another sysctl and should remain independent 
> of various workloads.

ok.

> However, I would recommend adding the word "MAX" to the config option.

MAX_PARALLEL_RECLAIM_TASK is good word?

- kosaki

