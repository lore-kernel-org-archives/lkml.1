Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYI3Xlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYI3Xlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYI3Xlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:41:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56294 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbYI3Xlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:41:44 -0400
Message-ID: <48E2B920.2020503@zytor.com>
Date: Tue, 30 Sep 2008 16:41:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: mtrr_cleanup update command line
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com> <20080930165739.7847be37.rdunlap@xenotime.net>
In-Reply-To: <20080930165739.7847be37.rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> 
> E.g., the "apic" entries are not grouped together and these mtrr entries should
> not be grouped together unless they all begin with "mtrr", which is an option here:
> they could be renamed to "mtrr-cleanup" and "mtrr-nocleanup".
> And "disable_mtrr_trim" could be renamed to "mtrr-notrim".
> 

That does collide with the (not always kept) convention of prefixing 
"no" to disable a boolean option, though.

	-hpa
