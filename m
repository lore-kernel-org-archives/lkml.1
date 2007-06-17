Return-Path: <linux-kernel-owner+w=401wt.eu-S1762950AbXFQKEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762950AbXFQKEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761453AbXFQJ5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:57:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761447AbXFQJ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:57:13 -0400
Date: Sun, 17 Jun 2007 02:55:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  (Re: regression tracking (Re: Linux 2.6.21))
Message-Id: <20070617025552.addd1c41.akpm@linux-foundation.org>
In-Reply-To: <467501D0.3090203@googlemail.com>
References: <p73d51n1fup.fsf@bingen.suse.de>
	<alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
	<200704291849.23197.rjw@sisk.pl>
	<20070429173725.GB30248@one.firstfloor.org>
	<alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
	<E1HyipW-0005wJ-0Q@flower>
	<alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org>
	<20070615234202.GP3588@stusta.de>
	<20070616013236.GA16016@flower.upol.cz>
	<4673D63D.5020804@s5r6.in-berlin.de>
	<20070617004436.GU3588@stusta.de>
	<467501D0.3090203@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2007 11:41:36 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> +If the patch introduces a new regression and this regression was not fixed
> +in seven days, then the patch will be reverted.

Those regressions where we know which patch caused them are the easy ones.
Often we don't know which patch (or even which subsystem merge) is at
fault.

I think.  How many of the present 2.6.22-rc regressions which you're
presently tracking have such a well-identified cause?
