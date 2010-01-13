Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602Ab0AMWXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab0AMWXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 17:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400Ab0AMWXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 17:23:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58369 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab0AMWXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 17:23:50 -0500
Date: Wed, 13 Jan 2010 23:23:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 5/5] x86: use dmi check to treat disabled cpus as
	hotplug cpus.
Message-ID: <20100113222348.GE24818@basil.fritz.box>
References: <1263338274-6485-1-git-send-email-yinghai@kernel.org> <1263338274-6485-5-git-send-email-yinghai@kernel.org> <1263340563.2854.1011.camel@sbs-t61.sc.intel.com> <4B4D0E39.10200@kernel.org> <87tyupfzk8.fsf@basil.nowhere.org> <4B4E427D.9090207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4E427D.9090207@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There are configurations in which percpu memory is in the megabytes.

There used to be some like this (with some broken debug code), but they
got all fixed i believe to only allocate on real cpu hotplug. 

If not the right way is to fix them, not add DMI blacklists.

Beside when you enable debug code you probably don't care about 
a few MB too much.

> This is exactly why we need high water mark allocation of percpu memory:

No we just need to fix any percpu pigs (if there are really any left,
I did a couple of patches some time ago)

"Don't work around broken code -- fix it"

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
