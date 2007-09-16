Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbXIPPxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbXIPPxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 11:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXIPPxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 11:53:24 -0400
Received: from ns1.suse.de ([195.135.220.2]:36441 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbXIPPxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 11:53:24 -0400
Date: Sun, 16 Sep 2007 17:53:21 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: crashme fault
Message-ID: <20070916155320.GE6708@v2.random>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 10:21:51PM -0700, Randy Dunlap wrote:
> I run almost-daily kernel testing.  I haven't seen 'crashme' cause a
> kernel fault until today, and now I've seen it twice on 2.6.23-rc6-git2,

Did the room temperature change in the server room? ;) Those early
EM64T P4 core based are fast but they suck a whole lot of power. It
seems a bitflip in a cpu register. You can use cpufreq to set low
frequency (they should support it, and they shouldn't use more than
100w per core that way) to lower the temp, and see if the problem goes
away. If it's a software issue it will hopefully be still reproducible
with ~2ghz instead of 3.4ghz.
