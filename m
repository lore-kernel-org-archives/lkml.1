Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbYBZWEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbYBZWEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763992AbYBZWEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:04:10 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:37539 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763509AbYBZWEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:04:08 -0500
Date: Tue, 26 Feb 2008 17:04:08 -0500
To: Jiri Kosina <jkosina@suse.cz>
Cc: Chris Holvenstot <cholvenstot@comcast.net>, elendil@planet.nl,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
Message-ID: <20080226220407.GY1287@csclub.uwaterloo.ca>
References: <Pine.LNX.4.64.0802161202430.7699@twin.jikos.cz> <1203163503.6124.5.camel@popeye> <Pine.LNX.4.64.0802161907200.30955@jikos.suse.cz> <1203221372.6124.29.camel@popeye> <Pine.LNX.4.64.0802211036580.30955@jikos.suse.cz> <1203587101.27355.4.camel@popeye> <20080226145832.GA1289@csclub.uwaterloo.ca> <Pine.LNX.4.64.0802261602030.30955@jikos.suse.cz> <20080226215812.GX1287@csclub.uwaterloo.ca> <Pine.LNX.4.64.0802262300000.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802262300000.30955@jikos.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 11:01:55PM +0100, Jiri Kosina wrote:
> OK, so what very probably happened is that CONFIG_GROUP_SCHED somehow 
> schedules X server in a way which confuses its sense of time, and 
> therefore makes autorepeat buggy ... ?

Well in my case this has been happening quite a long time, and I am
currently running 2.6.22 from Debian and I don't see any such config
option in the config.

$ grep SCHED /boot/config-2.6.22-3-k7
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_NET_SCHED=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_SCHEDSTATS is not set

So no idea what could have started the problem originally.  I guess I
have to start booting some older kernels and seeing if that helps.

--
Len Sorensen
