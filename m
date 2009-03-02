Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZCBNQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZCBNQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 08:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZCBNQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 08:16:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41475 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZCBNQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:16:26 -0500
Subject: Re: lockdep and threaded IRQs (was: ...)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
In-Reply-To: <200902271518.58246.david-b@pacbell.net>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	 <200902271350.32380.david-b@pacbell.net>
	 <20090227140907.f159be9b.akpm@linux-foundation.org>
	 <200902271518.58246.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 14:16:10 +0100
Message-Id: <1235999770.5330.367.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 15:18 -0800, David Brownell wrote:
> 
> This stuff just pokes at some annoying current gaps in the
> IRQ framework.  I'll be glad when eventually there's no
> need to work around those weaknesses ... that is, when
> real threaded IRQ support is available.

Its unfortunate that you prefer these dinky little hacks over helping
out providing whatever infrastructure you need.

There's plenty good reasons for mandating that irq handlers run with
irqs disabled, if you need threaded handlers -- that's fine, but then
teach the generic code about them.

What you do _NOT_ do is hack your way around things, that's not how
Linux works, and by doing that you make the world a slightly worse place
for everyone.

