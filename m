Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbXLGJgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbXLGJgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 04:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbXLGJgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 04:36:23 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:47669 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbXLGJgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 04:36:22 -0500
Date: Fri, 7 Dec 2007 10:29:38 +0100
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071207102938.5ca48859@inria.fr>
In-Reply-To: <20071207085121.GA12625@elte.hu>
References: <20071207021952.6f0ac922@morte>
	<alpine.LFD.0.99999.0712070646210.3221@localhost.localdomain>
	<3d8471ca0712062318j483f8be6h256778752a13639a@mail.gmail.com>
	<20071207090252.1caf1509@inria.fr>
	<20071207085121.GA12625@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Fri, 7 Dec 2007 09:51:21 +0100,
Ingo Molnar <mingo@elte.hu> a écrit :

> yeah, we can do something like this in 2.6.25 - this will improve the 
> quality of sched_clock().

Thanks a lot for your interest!

I'll clean it up and resend it later. As I don't have the necessary
knowledge to do the tsc_{32,64}.c unification, should I copy paste
common functions into tsc_32.c and tsc_64.c to ease later unification
or should I start a common .c file?

Thanks again for showing interest.

-- 
Guillaume
