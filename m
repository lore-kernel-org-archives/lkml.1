Return-Path: <linux-kernel-owner+w=401wt.eu-S1422801AbXBALgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422801AbXBALgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422816AbXBALgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:36:32 -0500
Received: from mail.suse.de ([195.135.220.2]:60002 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422801AbXBALgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:36:31 -0500
From: Andi Kleen <ak@suse.de>
To: jbohac@suse.cz
Subject: Re: [patch 6/9] Add the "Master Timer"
Date: Thu, 1 Feb 2007 12:22:55 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <20070201103753.944245000@jet.suse.cz>
In-Reply-To: <20070201103753.944245000@jet.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011222.56056.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  
> -unsigned int cpu_khz;					/* TSC clocks / usec, not used here */
> +unsigned int cpu_khz;		/* TSC clocks / usec, not used here */
> +static s64 mt_per_tick;		/* master timer ticks per jiffie */
> +static u64 __mt;		/* master timer */
> +static u32 __mt_last;		/* value last read from read_master_timer() when updating timer caches */

Why the underscores? 

-Andi
