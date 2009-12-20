Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbZLTOvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbZLTOvy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 09:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZLTOvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 09:51:53 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40154 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbZLTOvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 09:51:52 -0500
Date: Sun, 20 Dec 2009 15:51:51 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sachin Sant <sachinp@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: CPU offline/online related hang with latest git
Message-ID: <20091220145151.GY4489@kernel.dk>
References: <4B2DF699.3090107@in.ibm.com> <1261315887.4314.8.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261315887.4314.8.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20 2009, Peter Zijlstra wrote:
> On Sun, 2009-12-20 at 15:34 +0530, Sachin Sant wrote:
> > With 2.6.33-rc1-git1 (dd59f6c..) i am having trouble with
> > CPU hotplug on multiple architectures. Trying to offline
> > a CPU results in a machine hang.
> 
> damnit, you're right.. it's getting stuck during hotplug on stop machine
> some place.
> 
> didn't notice it because it didn't crash.. 
> 
> sorry for that :-(

Perhaps this is also why suspend doesn't work on current -git... -rc1 is
fine.

-- 
Jens Axboe

