Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbXIPQSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbXIPQSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 12:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXIPQSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 12:18:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63151 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbXIPQSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 12:18:06 -0400
Date: Sun, 16 Sep 2007 09:17:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: crashme fault
Message-Id: <20070916091754.a2ab62a2.randy.dunlap@oracle.com>
In-Reply-To: <20070916155320.GE6708@v2.random>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
	<20070916155320.GE6708@v2.random>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Sep 2007 17:53:21 +0200 Andrea Arcangeli wrote:

> On Wed, Sep 12, 2007 at 10:21:51PM -0700, Randy Dunlap wrote:
> > I run almost-daily kernel testing.  I haven't seen 'crashme' cause a
> > kernel fault until today, and now I've seen it twice on 2.6.23-rc6-git2,
> 
> Did the room temperature change in the server room? ;) Those early

I rarely go there, but when I do, it's usually very cool.
But I have no way of tracking the room temp there.

> EM64T P4 core based are fast but they suck a whole lot of power. It
> seems a bitflip in a cpu register. You can use cpufreq to set low
> frequency (they should support it, and they shouldn't use more than
> 100w per core that way) to lower the temp, and see if the problem goes
> away. If it's a software issue it will hopefully be still reproducible
> with ~2ghz instead of 3.4ghz.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
