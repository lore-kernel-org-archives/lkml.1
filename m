Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbYJ0UJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbYJ0UJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYJ0UJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:09:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47549 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752163AbYJ0UJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:09:04 -0400
Date: Mon, 27 Oct 2008 20:09:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH 2/2] rtc: rtc-wm8350: Add support for
	WM8350 RTC
Message-ID: <20081027200900.GA31757@rakim.wolfsonmicro.main>
References: <1225121905-23782-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1225121905-23782-2-git-send-email-broonie@opensource.wolfsonmicro.com> <20081027180432.7deaee0a@i1501.lan.towertech.it> <200810271303.21634.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200810271303.21634.david-b@pacbell.net>
X-Cookie: Slow day.  Practice crawling.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 01:03:21PM -0700, David Brownell wrote:
> On Monday 27 October 2008, Alessandro Zummo wrote:
> >  (and a detailed checklist at http://groups.google.com/group/rtc-linux/web/checklist )

> Also:  rtc_ops.ioctl() method should only handle RTC_{AIE,UIE}_{ON,OFF},
> since the other standard ioctls have rtc_ops equivalents.

> (This code is fine in both respects.  Though since I've received three
> copies of the driver since it was merged to MM, maybe I missed something.)

Unfortunately I added the __devexit_p() annotation in response to
Alessandro's comments.  I'll remove it again, other than that all that's
changed is a tweak to the module description and Andrew's change to use
schedule_timeout_uninterruptible().

How should these drivers be merged?
