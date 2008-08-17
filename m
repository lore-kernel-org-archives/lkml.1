Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbYHQCYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbYHQCYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 22:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYHQCYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 22:24:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56506 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbYHQCYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 22:24:23 -0400
Date: Sun, 17 Aug 2008 04:25:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Warning in during hotplug on 2.6.27-rc2-git5
Message-ID: <20080817022558.GO19125@one.firstfloor.org>
References: <200808141753.58547.rjw@sisk.pl> <20080814163450.GA13814@one.firstfloor.org> <6453C3CB8E2B3646B0D020C112613273C5AC71@sausexmb4.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273C5AC71@sausexmb4.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm still seeing it on 2.6.27-rc2, even with the 
> patch here http://lkml.org/lkml/2008/7/30/171 and the
> wbinvd_halt code patch applied.  Maybe something else
> broke in some of the recent hotplug changes?

Mark, can you please put a printk

printk("mce_cpu_callback action %lu cpu %u\n", action, cpu);

into arch/x86/kernel/cpu/mcheck/mce_64.c:mce_cpu_callback() 
and post the log including the warning? 

That would verify my theory.

-Andi

