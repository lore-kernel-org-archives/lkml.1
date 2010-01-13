Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425Ab0AMVqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab0AMVqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041Ab0AMVqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:46:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58439 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab0AMVqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:46:36 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 5/5] x86: use dmi check to treat disabled cpus as hotplug cpus.
From: Andi Kleen <andi@firstfloor.org>
References: <1263338274-6485-1-git-send-email-yinghai@kernel.org>
	<1263338274-6485-5-git-send-email-yinghai@kernel.org>
	<1263340563.2854.1011.camel@sbs-t61.sc.intel.com>
	<4B4D0E39.10200@kernel.org>
Date: Wed, 13 Jan 2010 22:46:31 +0100
In-Reply-To: <4B4D0E39.10200@kernel.org> (Yinghai Lu's message of "Tue, 12 Jan 2010 16:05:13 -0800")
Message-ID: <87tyupfzk8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:
>
> so you want to treat those disabled cpus in the those system as hotplug cpus or not?

Why not? It's not that a hotplug cpu is particularly expensive.
It's just a bunch of memory and not even very much of it.

White and blacklists just to save a small amount of memory
seem like a bad idea.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
