Return-Path: <linux-kernel-owner+w=401wt.eu-S1759179AbYF0GKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179AbYF0GKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbYF0GKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:10:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41255 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758135AbYF0GKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:10:01 -0400
Message-ID: <48648433.6070200@garzik.org>
Date: Fri, 27 Jun 2008 02:09:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 5/4] Fix forcedeth hibernate/wake-on-lan problems
References: <20080518125715.GA19229@yamamaya.is-a-geek.org> <20080531225442.GA2747@yamamaya.is-a-geek.org>
In-Reply-To: <20080531225442.GA2747@yamamaya.is-a-geek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
> 
> We currently don't signal the kernel we that this device can wake
> the system.  Call device_init_wakeup() to correct this.
> Without this device_can_wakeup and device_may_wakeup will return
> incorrect values.
> Together with the minimized acpi wakeup patch (6/4 ;)), which will
> follow in the next mail, this really makes wake-on-lan work for me
> as expected (i.e. "ethtool -s eth0 wol g" is sufficient, no
> additional magic needed).
> 
> Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>

applied 5-6


