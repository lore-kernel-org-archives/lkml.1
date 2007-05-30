Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbXE3P5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbXE3P5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbXE3P5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:57:06 -0400
Received: from www.osadl.org ([213.239.205.134]:49660 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751632AbXE3P5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:57:05 -0400
Subject: Re: add_timer_on and CONFIG_NO_HZ
From: Thomas Gleixner <tglx@linutronix.de>
To: Joe Korty <joe.korty@ccur.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070530132844.GA3630@tsunami.ccur.com>
References: <20070530132844.GA3630@tsunami.ccur.com>
Content-Type: text/plain
Date: Wed, 30 May 2007 17:57:00 +0200
Message-Id: <1180540620.3930.1.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe,

On Wed, 2007-05-30 at 09:28 -0400, Joe Korty wrote:
> Hi Thomas,
>  It seems that when add_timer_on() is used to put a timer
> on another cpu's timer queue, that remote cpu should be
> made to reprogram its hardware APIC timer, when CONFIG_NO_HZ=y
> and the new timer is put at the front of the timer wheel.

indeed, that makes sense. I look into this. Thanks for pointing it out.

	tglx


