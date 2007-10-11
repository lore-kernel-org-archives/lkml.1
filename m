Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbXJKTiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbXJKTiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 15:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbXJKThz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 15:37:55 -0400
Received: from rtr.ca ([76.10.145.34]:3028 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbXJKThy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 15:37:54 -0400
Message-ID: <470E7B90.5060203@rtr.ca>
Date: Thu, 11 Oct 2007 15:37:52 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: crash@treysoft.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: hdparm standby timeout not working for WD raptors?
References: <71b295590710061011g3cd43317i8eff3a7dce2a188@mail.gmail.com>
In-Reply-To: <71b295590710061011g3cd43317i8eff3a7dce2a188@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Weber wrote:
> I can't get "hdparm -S" to work at all.
> 
> Using  "hdparm -S 1" should set the timeout to
> 5 seconds,  but the drives stay active/idle all the
> time. When I set to standby manually, the drives
> stay on standby for days, and start up fine when
> they are used. I know this because I logged status
> every 30 minutes using crontab.
> 
> They just don't standby automatically.
> 
> I'm using 5 identical drives (see below for drive
> info), with software RAID.

I don't have Raptors here anymore to try it with,
but "hdparm -S1 /dev/sd?" did work fine with them
when last tried.

What do you get when you try this:

hdparm -S1 -C /dev/sda;sleep 6; hdparm -C /dev/sda


??
