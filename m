Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbYDAUbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbYDAUbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758396AbYDAUbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:31:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758272AbYDAUbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:31:00 -0400
Date: Tue, 1 Apr 2008 13:30:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for 2.6.25] Markers - use synchronize_sched()
Message-Id: <20080401133017.9484a35b.akpm@linux-foundation.org>
In-Reply-To: <20080331131609.GA22207@Krystal>
References: <20080331131609.GA22207@Krystal>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008 09:16:09 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Use synchronize_sched before calling call_rcu in CONFIG_PREEMPT_RCU until we
> have call_rcu_sched and rcu_barrier_sched in mainline. It will slow down the
> marker operations in CONFIG_PREEMPT_RCU, but it fixes the current race against
> the preempt_disable/enable() protected code paths.

A better changelog would have described the bug which is being fixed.

> Paul, is this ok ? It would be good to get this in for 2.6.25 final.

Paul seems to have nodded off.  I'll merge it.
