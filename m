Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbXEKImU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbXEKImU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbXEKIl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:41:59 -0400
Received: from quechua.inka.de ([193.197.184.2]:38305 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbXEKIl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:41:57 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] "volatile considered harmful", take 2
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <6143.1178828419@lwn.net>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1HmQhG-00057A-00@calista.eckenfels.net>
Date: Fri, 11 May 2007 10:41:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <6143.1178828419@lwn.net> you wrote:
> +Consider a typical block of kernel code:
> +
> +    spin_lock(&the_lock);
> +    do_something_on(&shared_data);
> +    do_something_else_with(&shared_data);
> +    spin_unlock(&the_lock);
> +
> +If all the code follows the locking rules, the value of shared_data cannot
> +change unexpectedly while the_lock is held.

Well maybe it is trivial, but I would add e.g. "all places where the
shared_data is accessed must be protected by this spinlock"

> +  - The jiffies variable is special in that it can have a different value

what about other atomic readable counters (like interface counters)?

Gruss
Bernd
