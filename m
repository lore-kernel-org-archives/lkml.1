Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYIFQa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYIFQa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 12:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYIFQaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 12:30:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:46818 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbYIFQaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 12:30:10 -0400
Date: Sat, 6 Sep 2008 09:30:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, tglx@tglx.de
Subject: Re: [PATCH 0/13] Turn hrtimers into a range capable timer
Message-ID: <20080906093005.007d994c@infradead.org>
In-Reply-To: <20080906145610.GA19692@elte.hu>
References: <20080901160343.75a89ec9@infradead.org>
	<20080906145610.GA19692@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Sep 2008 16:56:10 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> hi Arjan,
> 
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > This series is a follow-on the the nanosecond select/poll series.
> > 
> > The goal of this series is to introduce the capability into
> > hrtimers to deal with a "range" rather than a specific point in
> > time. (Several people discussed this recently, but we've been
> > toying with the concept for a while)
> 
> i've started doing some QA of this series in -tip.
> 
> it has a new -git based topic: tip/timers/range-hrtimers.
> 
> testing found this build failure:
> 

ok I fixed this in the master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-hrtimer.git
