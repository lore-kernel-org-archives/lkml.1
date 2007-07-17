Return-Path: <linux-kernel-owner+w=401wt.eu-S1758515AbXGQMk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515AbXGQMk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbXGQMkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:40:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbXGQMkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:40:21 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch-mm 01/33] clockevents: Remove unused inline function
Date: Tue, 17 Jul 2007 14:33:13 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de> <20070715155540.679507835@inhelltoy.tec.linutronix.de>
In-Reply-To: <20070715155540.679507835@inhelltoy.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171433.14056.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 July 2007 18:10:42 Thomas Gleixner wrote:

> Index: linux-2.6.22-rc6-mm/include/linux/clockchips.h
> ===================================================================
> --- linux-2.6.22-rc6-mm.orig/include/linux/clockchips.h	2007-07-15 09:44:00.000000000 +0200
> +++ linux-2.6.22-rc6-mm/include/linux/clockchips.h	2007-07-15 17:49:11.000000000 +0200
> @@ -131,7 +131,6 @@ extern void clockevents_notify(unsigned 
>  
>  #else
>  
> -static inline void clockevents_resume_events(void) { }
>  #define clockevents_notify(reason, arg) do { } while (0)


Unrelated. Surely you can just send? 

-Andi
