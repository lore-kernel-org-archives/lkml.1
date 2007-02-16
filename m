Return-Path: <linux-kernel-owner+w=401wt.eu-S1946000AbXBPRBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946000AbXBPRBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946008AbXBPRBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:01:23 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:34464 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946004AbXBPRBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:01:22 -0500
Date: Fri, 16 Feb 2007 19:58:54 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: ray-gmail@madrabbit.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070216165854.GA18522@2ka.mipt.ru>
References: <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org> <20070215181059.GC20997@2ka.mipt.ru> <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org> <20070215190413.GA23953@2ka.mipt.ru> <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org> <20070216085706.GA22868@2ka.mipt.ru> <Pine.LNX.4.64.0702160753120.20368@woody.linux-foundation.org> <20070216160525.GA21160@2ka.mipt.ru> <2c0942db0702160853s18f650ccsa7270c047d94a41b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <2c0942db0702160853s18f650ccsa7270c047d94a41b@mail.gmail.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Fri, 16 Feb 2007 19:59:02 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 08:53:30AM -0800, Ray Lee (madrabbit@gmail.com) wrote:
> On 2/16/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> >if its design is good, then
> >interface can be changed in a moment without any problem
> 
> This isn't always the case. Sometimes the interface puts requirements
> (contract-like) upon the implementation. Case in point in the kernel,
> dnotify versus inotify. dnotify is a steaming pile of worthlessness,
> because it's userspace interface is so bad (meaning inefficient) as to
> be nearly unusable.
> 
> inotify has a different interface, one that supplies details about
> events rather that mere notice that an event occurred, and therefore
> has different requirements in implementation. dnotify probably was a
> good design, but for a worthless interface.
> 
> The interface isn't always important, but it's certainly something
> that has to be understood before putting the finishing touches on the
> behind-the-scenes implementation.

Absolutely.
And if overall system design is good, there is no problem to change
(well, for those who fail to read to the end and understand my english
replace 'to change' with 'to create and commit') interface to the state
where it will satisfy all (majority of) users.

Situations when system is designed from interface down to system ends up
with one thread per IO and huge limitations on how system is going to be
used at all.

> Ray

-- 
	Evgeniy Polyakov
