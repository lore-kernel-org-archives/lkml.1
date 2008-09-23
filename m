Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbYIWKvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbYIWKvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 06:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYIWKvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 06:51:31 -0400
Received: from www.tglx.de ([62.245.132.106]:57174 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbYIWKva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 06:51:30 -0400
Date: Tue, 23 Sep 2008 12:50:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Joshua Hoblitt <j_kernel@hoblitt.com>
Subject: Re: [Bug #11543] kernel panic: softlockup in tick_periodic() ???
In-Reply-To: <7lIhZC4hCxE.A.zJH.p0q1IB@albercik>
Message-ID: <alpine.LFD.1.10.0809231244190.3247@apollo.tec.linutronix.de>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik> <7lIhZC4hCxE.A.zJH.p0q1IB@albercik>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Sep 2008, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11543
> Subject		: kernel panic: softlockup in tick_periodic() ???

The softlockup issue itself is fixed, but there are issues with
nmi_watchdog. I think we should remove the regression and keep the bug
alive to chase the other issues.

Thanks,

	tglx

