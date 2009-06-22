Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbZFVO7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbZFVO7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZFVO7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:59:37 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:53439 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZFVO7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:59:37 -0400
Date: Mon, 22 Jun 2009 16:59:36 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 0/2] NOHZ vs. profile/oprofile v2
Message-ID: <20090622165936.0bb776e1@skybase>
In-Reply-To: <20090622144110.GA9771@elte.hu>
References: <20090603152223.083010123@de.ibm.com>
	<alpine.LFD.2.00.0906092252150.3351@localhost.localdomain>
	<20090622162631.4b4dcee4@skybase>
	<20090622144110.GA9771@elte.hu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 16:41:10 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> Hm, this is rather ugly. Why not use hrtimers like 'perf' does when 
> it fallback-samples based on the timer tick?
> 
> That method has three advantages:
> 
>  - no weird hookery needed
>  - resolution can go far beyond HZ
>  - it is evidently dynticks-safe

Hmm, if we replace the HZ based oprofile tick with an hrtimer we should
add an interface to configure the sample interval as well, no? Otherwise
we just replace one timer event (HZ) with another (hrtimer).

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

