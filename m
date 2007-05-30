Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbXE3Njn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbXE3Njn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbXE3Njf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:39:35 -0400
Received: from flvpn.ccur.com ([66.10.65.2]:32127 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751449AbXE3Nje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:39:34 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 May 2007 09:39:34 EDT
Date: Wed, 30 May 2007 09:28:44 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: add_timer_on and CONFIG_NO_HZ
Message-ID: <20070530132844.GA3630@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
 It seems that when add_timer_on() is used to put a timer
on another cpu's timer queue, that remote cpu should be
made to reprogram its hardware APIC timer, when CONFIG_NO_HZ=y
and the new timer is put at the front of the timer wheel.

Regards,
Joe

