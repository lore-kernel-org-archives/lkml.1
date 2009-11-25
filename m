Return-Path: <linux-kernel-owner+w=401wt.eu-S1751280AbZKYI2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbZKYI2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZKYI2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:28:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52971 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZKYI2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:28:16 -0500
Subject: Re: [RFC][PATCH 0/7] perf trace: general-purpose scripting
 support, v2
From: Peter Zijlstra <peterz@infradead.org>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       rostedt@goodmis.org, anton@samba.org, hch@infradead.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
References: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 09:28:15 +0100
Message-ID: <1259137695.4027.45.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 01:15 -0600, Tom Zanussi wrote:
> sched::sched_wakeup      0 01238.657997033     6183 firefox              comm=firefox, pid=6199, prio=120, success=1, target_cpu=1
> sched::sched_switch      1 01238.657991740     7140 firefox              prev_comm=firefox, prev_pid=7140, prev_prio=120, prev_state=S, next_comm=firefox, next_pid=6199, next_prio=120
> 
> min_wakeup_latency: -5293 

Looks like we missed a clock update on the cross cpu wakeup, Mike was
busy plugging those holes -- I've been starting at a patch that might
cure this (amongst other things).



