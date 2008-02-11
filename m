Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbYBKLBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbYBKLBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYBKLBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:01:42 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:20959 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbYBKLBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:01:41 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/8] CPA: Fix gbpages support in try_preserve_lage_page
References: <200802111034.764275766@suse.de>
	<20080211093429.CD9D31B41CE@basil.firstfloor.org>
	<alpine.LFD.1.00.0802111043340.12988@apollo.tec.linutronix.de>
	<20080211101208.GA32181@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 11 Feb 2008 12:01:39 +0100
In-Reply-To: <20080211101208.GA32181@elte.hu>
Message-ID: <87ir0viwoc.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Feb 2008 10:55:17.0923 (UTC) FILETIME=[96B56F30:01C86C9C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
> 
> btw., v2.6.25-rc1 is not affected by this. Gbpages support is a "still 
> cooking" feature only available in x86.git#mm, destined for .26, and 
> even there it's default disabled and only available on Barcelona class 
> hardware. (Some of these bits are upstream already to make maintenance 
> easier, but they are inactive code.)

This means it will be tested for ~6 months. Don't you think that's a little
excessive for such a simple patch? 

% git show 6dc6ffff706db6c70a98253e7dc7011e4343df6c | diffstat 
 init_64.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

One option would be also to merge it to .25 and mark the
CONFIG option EXPERIMENTAL.

-Andi
