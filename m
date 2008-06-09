Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbYFIWE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbYFIWE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYFIWEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:04:21 -0400
Received: from mx0.towertech.it ([213.215.222.73]:58463 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752668AbYFIWEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:04:20 -0400
Date: Tue, 10 Jun 2008 00:04:13 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, zippel@linux-m68k.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NTP: Let update_persistent_clock() sleep
Message-ID: <20080610000413.0de0bc41@i1501.lan.towertech.it>
In-Reply-To: <20080609145923.fe5dc86d.akpm@linux-foundation.org>
References: <Pine.LNX.4.55.0805281856200.29522@cliff.in.clinika.pl>
	<20080528201612.d2641dc3.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0806091950360.6791@localhost.localdomain>
	<Pine.LNX.4.55.0806091912390.26593@cliff.in.clinika.pl>
	<20080609145923.fe5dc86d.akpm@linux-foundation.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008 14:59:23 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> Are there any objections to the patch under discussion?
> 
> Thanks.
> 
> 
> From: "Maciej W. Rozycki" <macro@linux-mips.org>
> 
> This is a change that makes the 11-minute RTC update be run in the process
> context.  This is so that update_persistent_clock() can sleep, which may
> be required for certain types of RTC hardware -- most notably I2C devices.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Roman Zippel <zippel@linux-m68k.org>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: David Brownell <david-b@pacbell.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

