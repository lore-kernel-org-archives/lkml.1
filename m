Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbXIAQCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbXIAQCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 12:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXIAQC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 12:02:29 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:1070 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbXIAQC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 12:02:28 -0400
Subject: Re: v2.6.23-rc4-rt1 / new project URL
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1188593944.9647.15.camel@chaos>
References: <1188593944.9647.15.camel@chaos>
Content-Type: text/plain
Date: Sat, 01 Sep 2007 08:50:40 -0700
Message-Id: <1188661841.11196.6.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 22:59 +0200, Thomas Gleixner wrote:

> - loadavgrt fix (Luis Claudio R. Goncalves)

Sven caught that this patch was broken, I think there is an updated
one.. It's also breaking !PREEMPT_RT compiles..

 dwalker2/140 failed
kernel/timer.c: In function 'calc_load':
kernel/timer.c:962: error: implicit declaration of function 'count_active_rt_tasks'
make[1]: *** [kernel/timer.o] Error 1


Daniel

