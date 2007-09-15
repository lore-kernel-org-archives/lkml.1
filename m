Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbXIOK6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbXIOK6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 06:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbXIOK6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 06:58:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45454 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618AbXIOK6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 06:58:12 -0400
Date: Sat, 15 Sep 2007 03:55:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Andi Kleen <ak@suse.de>, Adrian Bunk <bunk@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
Message-Id: <20070915035553.499fea1d.akpm@linux-foundation.org>
In-Reply-To: <20070912002953.GA26293@linux-sh.org>
References: <20070911201219.GA9674@uranus.ravnborg.org>
	<200709112138.11247.ak@suse.de>
	<20070911211422.GU3563@stusta.de>
	<200709112234.24155.ak@suse.de>
	<20070912002953.GA26293@linux-sh.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 09:29:53 +0900 Paul Mundt <lethal@linux-sh.org> wrote:

> As I was the first one to do CONFIG_MMU=y/n in the same arch directory,
> since 2.5, I can tell you that that's simply crap. The only reason
> CONFIG_MMU=n gets broken all the time is because people don't think about
> it in generic code, it's rarely broken in the architecture code, and even
> with the most occasional of build tests most of that gets caught in a
> hurry.

oy.  I do sh allmodconfig test builds fairly regularly.

<does one>

It all went OK, up until moddep:

ERROR: "_ebss" [drivers/mtd/maps/uclinux.ko] undefined!

