Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbXLBUKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbXLBUKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:10:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbXLBUJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:09:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55880 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbXLBUJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:09:55 -0500
Date: Sun, 2 Dec 2007 21:09:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071202200953.GA23994@one.firstfloor.org>
References: <20071201092037.GA32544@elte.hu> <p737ijwylet.fsf@bingen.suse.de> <20071202185945.GA25990@elte.hu> <20071202114152.3bf4332d@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071202114152.3bf4332d@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> .. and it's even a tool to show where we missed making something
> TASK_KILLABLE... anything that triggers from NFS and the like really
> ought to be TASK_KILLABLE after all. This patch will point any
> omissions out quite nicely without having to do any kind of destructive
> testing.

It would be better to just audit the source for those. Outlawing
something which was previously legal without auditing the source
is bad.

Anyways, i suspect it would just lead to more people disabling
softlockup. I remember during some older stress testing it also
tended to explode regularly, so e.g. SUSE kernel rpms have it disabled.
That patch would probably make it worse.

-Andi
