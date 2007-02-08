Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbXBHSfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbXBHSfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 13:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXBHSfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 13:35:31 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:36264 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbXBHSfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 13:35:30 -0500
X-Greylist: delayed 2050 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Feb 2007 13:35:30 EST
Date: Thu, 8 Feb 2007 19:01:19 +0100
From: Adrian Reber <adrian@lisas.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, Milton Miller <miltonm@bga.com>,
       Carl Love <cel@us.ibm.com>
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated patch
Message-ID: <20070208180119.GA24743@lisas.de>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>, cbe-oss-dev@ozlabs.org,
	linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>,
	Milton Miller <miltonm@bga.com>, Carl Love <cel@us.ibm.com>
References: <1170721711.5204.44.camel@dyn9047021078.beaverton.ibm.com> <1170802957.5204.56.camel@dyn9047021078.beaverton.ibm.com> <b682962303654f4958a6c2c50d805907@bga.com> <200702081821.57358.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702081821.57358.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
X-Url: <http://lisas.de/~adrian/>
X-Operating-System: Linux (2.6.18-1.2869.fc6)
X-Load-Average: 0.74 1.41 2.14
X-Unexpected: The Spanish Inquisition
X-GnuPG-Key: gpg --keyserver sks.keyserver.penguin.de --recv-keys 3ED6F034
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 06:21:56PM +0100, Arnd Bergmann wrote:
[...]
> Moving the sample rate computation to user space sounds like the right
> idea, but why not have a more drastic version of it:
> 
> Right now, all products that support this feature run at the same clock
> rate (3.2 Ghz), with cpufreq, we can reduce this to 1.6 Ghz. If I understand
> this correctly, the value depends only on the frequency, so we could simply
> hardcode this in the kernel, and print out a warning message if we ever
> encounter a different frequency, right?

Just for the record... CAB is running with 2.8 GHz. At least all the boards
I have seen.

		Adrian
