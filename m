Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183Ab0A1NvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0A1NvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 08:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944Ab0A1NvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 08:51:14 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:57624 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932208Ab0A1NvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 08:51:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjQBAJskYUtLd/sX/2dsb2JhbAAIgy/HPoIZAY1DgSqCOVkE
X-IronPort-AV: E=Sophos;i="4.49,359,1262581200"; 
   d="scan'208";a="54736741"
Message-ID: <4B61964F.6060307@teksavvy.com>
Date: Thu, 28 Jan 2010 08:51:11 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Mel Gorman <mel@csn.ul.ie>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: 2.6.32.5 regression: page allocation failure. order:1,
References: <4B5FA147.5040802@teksavvy.com> <4B610FDA.50104@teksavvy.com> <4B6113C7.201@teksavvy.com> <201001281152.20352.rjw@sisk.pl>
In-Reply-To: <201001281152.20352.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Have you attached a (2.6.31.x) dmesg output from the failing box somewhere
> or have I just missed it?
..

The log from failing on 2.6.32.5 was linked to originally:

   http://rtr.ca/2.6.32_page_alloc_fail_logs.txt 

Here's the subsequent revert reboot back to 2.6.32.12:

   http://rtr.ca/2.6.31.12_ok_logs.txt

In the time available thus far, I haven't managed to get 2.6.32.5
to boot/run on anything else, using either a UP kernel, or "nosmp",
along with "mem=512M".

With a bit of luck, I'll have another similar VIA C7 box delivered here by tonight,
and should be able to boot/run that off a cloned disk image from the original system.

Then we can poke at things a bit more.
If the box works, it will be 100% at our disposal.

Note that it's far too slow for practical direct use of git-bisect,
taking hours to rebuild its own kernels.  It might be possible,
with a fair bit of effort, to arrange a quad-core box to do the
kernel compiles for it, though.

Cheers 
