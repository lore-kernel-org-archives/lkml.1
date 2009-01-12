Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbZALOcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbZALOcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 09:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZALOcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 09:32:33 -0500
Received: from cmpxchg.org ([85.214.51.133]:56402 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbZALOcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 09:32:33 -0500
Date: Mon, 12 Jan 2009 15:32:15 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mandeep Singh Baines <msb@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com
Subject: Re: [PATCH v2] softlockup: decouple hung tasks check from softlockup detection
Message-ID: <20090112143215.GA18281@cmpxchg.org>
References: <20090112065213.GA19795@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112065213.GA19795@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 10:52:13PM -0800, Mandeep Singh Baines wrote:
> Decoupling allows:
> 
> * hung tasks check to happen at very low priority
> * hung tasks check and softlockup to be enabled/disabled independently
>   at compile and/or run-time
> * individual panic settings to be enabled disabled independently
>   at compile and/or run-time
> * softlockup threshold to be reduced without increasing hung tasks
>   poll frequency (hung task check is expensive relative to softlock watchdog)
> * hung task check to be zero over-head when disabled at run-time
> ---
>  include/linux/sched.h |   14 +++++--
>  kernel/Makefile       |    1 +
>  kernel/softlockup.c   |  102 -------------------------------------------------
>  kernel/sysctl.c       |   15 +++++++-
>  lib/Kconfig.debug     |   38 ++++++++++++++++++
>  5 files changed, 63 insertions(+), 107 deletions(-)

kernel/hung_task.c missing?

	Hannes
