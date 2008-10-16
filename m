Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYJPQKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYJPQKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYJPQKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:10:23 -0400
Received: from samwise.efn.org ([12.33.21.33]:53968 "EHLO samwise.efn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYJPQKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:10:22 -0400
X-Greylist: delayed 1997 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Oct 2008 12:10:22 EDT
To: linux-kernel@vger.kernel.org
Subject: RE: OMAP3430 spurious interrupts
Reply-To: rick@efn.org
Message-Id: <E1KqUu7-0005vQ-7O@amazonia.comcast.net>
From: Rick Bronson <rick@efn.org>
Date: Thu, 16 Oct 2008 08:36:47 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  I'm getting some info on the spurious interrupt that's happening
upon startup about once in 10-15 reboots.  By the way, I'm using
2.6.26-omap1 from the latest Open Embedded with Lauri's spurious
patch.  Here's what I'm seeing.  There is a barrage of interrupts on,
in one scenario A) from the Display Subsystem Module and in another
scenario B) I2C Module One.  This barrage leads up to
omap2_gp_timer_interrupt() happening and then in case A) an immediate
spurious GPTIMER interrupt.  In case B) a spurious GPTIMER interrupt
7.8ms later.  7.8ms is the time the GPTIMER is set for (128 Hz).

  I think the first thing to do is find out how to prevent the
spurious interrupt from happening.  The next thing to do is to solve
the barrage of interrupts upon startup.

  The question I have for you is this: Looking at page 1308 of 3446 of
the OMAP3 pdf "Spurious Interrupt Handling", it's not clear to me,
from a programming perspective, how to check if (when changing the
registers mentioned) we are encountering this condition.  If we
can't test for this condition, how can it be avoided?

  Thanks for your help.

  Rick Bronson
