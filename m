Return-Path: <linux-kernel-owner+w=401wt.eu-S1759074AbXFZRg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074AbXFZRg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbXFZRgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:36:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44127 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756714AbXFZRgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:36:49 -0400
Date: Tue, 26 Jun 2007 10:36:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Message-Id: <20070626103610.8d4dc830.akpm@linux-foundation.org>
In-Reply-To: <20070625151508.86fa3778.akpm@linux-foundation.org>
References: <20070625200601.GA18980@elte.hu>
	<200706252309.47467.zippel@linux-m68k.org>
	<20070625151508.86fa3778.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 15:15:08 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> > What did you test?
> > There can be many ways to read the clock, do you want to put this hook 
> > everywhere?
> 
> Yeah, it isn't immediately obvious (to this little black duck) why similar
> fixups weren't needed in timekeeping.c.

did this get addressed?
