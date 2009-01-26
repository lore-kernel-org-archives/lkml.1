Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZAZTyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZAZTyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZAZTyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:54:39 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:51240 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbZAZTyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:54:38 -0500
Date: Tue, 27 Jan 2009 01:24:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       Arve Hj?nnev?g <arve@android.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Menage <menage@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-ID: <20090126195431.GC504@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <200901211638.23101.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200901211638.23101.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nikanth Karthikesan <knikanth@suse.de> [2009-01-21 16:38:21]:

> As Alan Cox suggested/wondered in this thread, 
> http://lkml.org/lkml/2009/1/12/235 , this is a container group based approach 
> to override the oom killer selection without losing all the benefits of the 
> current oom killer heuristics and oom_adj interface.
> 
> It adds a tunable oom.victim to the oom cgroup. The oom killer will kill the 
> process using the usual badness value but only within the cgroup with the 
> maximum value for oom.victim before killing any process from a cgroup with a 
> lesser oom.victim number. Oom killing could be disabled by setting 
> oom.victim=0.

Looking at the patch, I wonder if it is time for user space OOM
notifications that were discussed during the containers mini-summit.
The idea is to inform user space about OOM's and let user space take
action, if no action is taken, the default handler kicks in.

-- 
	Balbir
