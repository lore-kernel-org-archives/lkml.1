Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbYCCJcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbYCCJcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYCCJcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:32:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:53984 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYCCJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:32:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: SCHED_IDLE documentation
Date: Mon, 3 Mar 2008 10:31:51 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Christoph Hellwig <hch@lst.de>, cbe-oss-dev@ozlabs.org,
       Jeremy Kerr <jk@ozlabs.org>, linux-kernel@vger.kernel.org
References: <1203376368.275756.252634247263.1.gpush@pokey> <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com> <20080303092422.GA18281@elte.hu>
In-Reply-To: <20080303092422.GA18281@elte.hu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031031.52335.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19AuBu6Wt/ZVFP2/F+ZXeQPUIkKcj38AkBcbwh
 byhIuTGmJIcn7cxGxf6pMnrGLKFJWjsTPt7dl2ZVG9br7hsjpV
 00oHIxfa+67mK36/wsVxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 March 2008, Ingo Molnar wrote:
> > * What's the difference between SCHED_IDLE and SCHED_BATCH?
> 
> SCHED_BATCH can still have nice levels from -20 to +19, it is a modified 
> SCHED_OTHER/SCHED_NORMAL for "throughput oriented" workloads.
> 
> SCHED_IDLE overrides the nice settings and it means a "super idle" 
> workload.

Does that mean that a SCHED_IDLE task still runs some of the time if
you have a CPU hog running on +19, or can any other process starve the
SCHED_IDLE task?

What happens if you have two SCHED_IDLE tasks on a single CPU, do they get
equal share, or will they just run as batch jobs?

	Arnd <><
