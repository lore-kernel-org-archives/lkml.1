Return-Path: <linux-kernel-owner+w=401wt.eu-S968668AbXEIF7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968668AbXEIF7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 01:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935097AbXEIF7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 01:59:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934722AbXEIF7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 01:59:40 -0400
Date: Tue, 8 May 2007 22:59:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Message-Id: <20070508225920.258d8d34.akpm@linux-foundation.org>
In-Reply-To: <1178463784.31213.46.camel@localhost.localdomain>
References: <20070430102837.748238000@linutronix.de>
	<20070430102852.042964000@linutronix.de>
	<20070505003421.00ec45ba.akpm@linux-foundation.org>
	<20070505115127.GA17815@elte.hu>
	<1178463784.31213.46.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 May 2007 17:03:03 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> Andrew,
> 
> On Sat, 2007-05-05 at 13:51 +0200, Ingo Molnar wrote:
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > > Fixup the existing users.
> > > 
> > > This one makes the Vaio-of-fun hang during suspend to disk.  It gets 
> > > up to "swsusp: critical section/: done (%d pages copied)" then it 
> > > freezes.
> > 
> > after trying to reproduce it on 2 boxes without success it did trigger 
> > some sw-suspend weirdness on a third box :) We are debugging it now.
> 
> find an updated patch below. It fixes the problem on Ingo's
> VAIO-of-fun-emulator and I got confirmation from several other affected
> users, that the patch series is still solving their problems.
> 

The machine is still hanging with this patch applied.

suspend-to-disk gets up to "swsusp: critical section: done (NNN pages copied)"

No netconsole, no printk-timestamping.

ho hum, I guess I get to debug this.
