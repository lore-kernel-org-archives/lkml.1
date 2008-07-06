Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbYGFJ0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbYGFJ0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 05:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYGFJZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 05:25:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56455 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYGFJZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 05:25:55 -0400
Message-ID: <48708F23.2080702@cn.fujitsu.com>
Date: Sun, 06 Jul 2008 17:23:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] rcu classic: new algorithm for callbacks-processing
References: <4844BE83.5010401@cn.fujitsu.com> <20080608151844.GA18751@linux.vnet.ibm.com> <485F17B2.5010700@cn.fujitsu.com> <20080623091349.GK22569@linux.vnet.ibm.com>
In-Reply-To: <20080623091349.GK22569@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:

> 
> You tried this without your changes and it passed, correct?
> 
> Never forget to test the base kernel.  ;-)
> 

Thanks, but I make some mistake here.

I tested the base kernel, no bug occurred.
So I try to find out bugs in my changes in 2 weeks.

I added debug codes and these codes showed all processing
are right and no callback broke its grace period
but the bug still occurred.

When I was puzzled after 2 weeks, I looked back the base
kernel that I had tested, and I found that I forget to set
CONFIG_NO_HZ=y.

Then I set CONFIG_NO_HZ=y in the base kernel, and the bug
occurred. It's exactly as the bug when my patch applied.

I have reported this bug here:
http://lkml.org/lkml/2008/7/3/24







