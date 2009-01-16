Return-Path: <linux-kernel-owner+w=401wt.eu-S1765579AbZAPL2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765579AbZAPL2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 06:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760172AbZAPL2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 06:28:42 -0500
Received: from www.tglx.de ([62.245.132.106]:38159 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbZAPL2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 06:28:40 -0500
Date: Fri, 16 Jan 2009 12:28:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnstul@us.ibm.com, lethal@linux-sh.org, mingo@redhat.com
Subject: Re: [RESEND][PATCH] clockevent: let set_mode() setup delta
 information
In-Reply-To: <20090116081438.12388.15130.sendpatchset@rx1.opensource.se>
Message-ID: <alpine.LFD.2.00.0901161227480.3400@localhost.localdomain>
References: <20090116081438.12388.15130.sendpatchset@rx1.opensource.se>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009, Magnus Damm wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> Allow the set_mode() clockevent callback to decide and fill in delta
> details such as shift, mult, max_delta_ns and min_delta_ns.
> 
> With this change the clockevent can be registered without delta details
> which allows us to keep the parent clock disabled until the clockevent
> gets setup using set_mode().
> 
> Letting set_mode() fill in or update delta details allows us to save
> power by disabling the parent clock while the clockevent is unused.
> This may however make the parent clock rate change, so next time the
> clockevent gets enabled we need let set_mode() to update the detla
> details accordingly. Doing it at registration time is not enough.
> 
> Furthermore, the delta details seem unused in the case of periodic-only
> clockevent drivers, so this change also allows registration of such
> drivers without the delta details filled in.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>

Applied to tip/timers/clockevents

Thanks,

	tglx
