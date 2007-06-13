Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbXFMJIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbXFMJIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 05:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbXFMJIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 05:08:40 -0400
Received: from ns2.suse.de ([195.135.220.15]:56467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082AbXFMJIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 05:08:40 -0400
Date: Wed, 13 Jun 2007 11:08:37 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Runaway process and oom-killer
Message-ID: <20070613090837.GD7443@v2.random>
References: <466FAF99.3070708@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466FAF99.3070708@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 10:49:29AM +0200, John Sigler wrote:
> Question 1: why isn't this output picked up by klogd and sent to the 
> appropriate file (kern.log in my case)?

I guess not a question for lkml, most distros uses syslog-ng anyway.

> Question 2: how can I tell which process or kernel thread was hogging 
> most of the RAM when the oom-killer kicked in?

Theoretically the one that was killed first but not for sure in
current mainline hence see below.

> Question 3: if myapp was hogging the RAM, then why did oom-killer snipe 
> other processes (syslogd and boa) after it killed myapp?

Please try again after applying this monolith (proper submission was
on linux-mm but the monolith is easier to apply for tests like this):

   http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.22-rc4/oom-fixes-1
