Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYF1Nsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYF1Nsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYF1Nsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:48:40 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49750 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbYF1Nsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:48:39 -0400
Date: Sat, 28 Jun 2008 15:48:44 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mmc: Add per-card debugfs support
Message-ID: <20080628154844.35a90ae9@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080628153745.027b0817@mjolnir.drzeus.cx>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-3-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628153745.027b0817@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2008 13:48:32.0579 (UTC) FILETIME=[A7699130:01C8D925]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> The status command doesn't work on SDIO cards, so this seems like the
> wrong place for it.

Where do you want it then?

Btw, /sys/class/mmc_host/mmc0/<card>/test doesn't work on SDIO cards
either:

mmc0: Starting tests of card mmc0:0001...
mmc0: Test case 1. Basic write (no data verification)...
mmc0: Result: ERROR (-110)
mmc0: Test case 2. Basic read (no data verification)...
mmc0: Result: ERROR (-110)
mmc0: Test case 3. Basic write (with data verification)...
mmc0: Result: Prepare stage failed! (-110)
mmc0: Test case 4. Basic read (with data verification)...
mmc0: Result: Prepare stage failed! (-110)
mmc0: Test case 5. Multi-block write...
mmc0: Result: Prepare stage failed! (-110)
mmc0: Test case 6. Multi-block read...
mmc0: Result: Prepare stage failed! (-110)
mmc0: Test case 7. Power of two block writes...
mmc0: Result: Prepare stage failed! (-110)
mmc0: Test case 8. Power of two block reads...
mmc0: Result: Prepare stage failed! (-110)
mmc0: Test case 9. Weird sized block writes...
mmc0: Result: Prepare stage failed! (-110)
mmc0: Test case 10. Weird sized block reads...
mmc0: Result: Prepare stage failed! (-110)
mmc0: Test case 11. Badly aligned write...
mmc0: Result: Prepare stage failed! (-110)
mmc0: Test case 12. Badly aligned read...
mmc0: Result: Prepare stage failed! (-110)
mmc0: Test case 13. Badly aligned multi-block write...
mmc0: Result: Prepare stage failed! (-110)
mmc0: Test case 14. Badly aligned multi-block read...
mmc0: Result: Prepare stage failed! (-110)
mmc0: Test case 15. Correct xfer_size at write (start failure)...
mmc0: Result: ERROR (-110)
mmc0: Test case 16. Correct xfer_size at read (start failure)...
mmc0: Result: ERROR (-110)
mmc0: Test case 17. Correct xfer_size at write (midway failure)...
mmc0: Result: ERROR (-110)
mmc0: Test case 18. Correct xfer_size at read (midway failure)...
mmc0: Result: ERROR (-110)
mmc0: Tests completed.

Haavard
