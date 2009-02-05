Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZBEVwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZBEVwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZBEVw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:52:26 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:41742 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZBEVwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:52:25 -0500
X-IronPort-AV: E=Sophos;i="4.37,387,1231113600"; 
   d="scan'208";a="133409096"
From: Roland Dreier <rdreier@cisco.com>
To: Andreas Schwab <schwab@suse.de>
Cc: Floris Kraak <randakar@gmail.com>, Robert Hancock <hancockrwd@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
	<20090204221451.GA27254@uranus.ravnborg.org>
	<adavdrplty2.fsf@cisco.com> <498A295A.4090008@gmail.com>
	<adaskmtjsnn.fsf@cisco.com>
	<56e1b5710902050026s5a8fd48fhf4a65c05a533dbc3@mail.gmail.com>
	<56e1b5710902050215l5b34adb1ofb8a972318ebe353@mail.gmail.com>
	<jeab91w54x.fsf@sykes.suse.de>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 05 Feb 2009 13:52:23 -0800
In-Reply-To: <jeab91w54x.fsf@sykes.suse.de> (Andreas Schwab's message of "Thu,
	05 Feb 2009 11:27:10 +0100")
Message-ID: <adaocxgk0vc.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Feb 2009 21:52:24.0418 (UTC) FILETIME=[07712420:01C987DC]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > So what is this "warn_no_rtc" thing?
 > >
 > >         static char             warn_no_rtc[] __initdata =
 > >                 KERN_WARNING "PM: no wakealarm-capable RTC driver is ready\n";
 > 
 > Does it help to make it const?

You can't make __initdata const, because the initdata section is not
read-only.

 - R.
