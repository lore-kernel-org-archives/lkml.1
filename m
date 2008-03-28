Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbYC1UJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbYC1UJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYC1UIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:08:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1328 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754293AbYC1UIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:08:40 -0400
Date: Fri, 28 Mar 2008 15:00:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Luciano Rocha <luciano@eurotux.com>, Michael Meyer <mike65134@yahoo.de>,
       linux-kernel@vger.kernel.org
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 > /sys/devices/system/cpu/cpu1/online"
Message-ID: <20080328140056.GC4404@ucw.cz>
References: <16336.23884.qm@web25814.mail.ukl.yahoo.com> <20080325140825.GA19722@bit.office.eurotux.com> <87abkmhgg0.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87abkmhgg0.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-03-25 18:16:47, Andi Kleen wrote:
> Luciano Rocha <luciano@eurotux.com> writes:
> 
> > On Tue, Mar 25, 2008 at 02:47:50PM +0100, Michael Meyer wrote:
> > > Hi, 
> > > 
> > > what is the difference between booting a dual core
> > > machine with "maxcpus=1" or by deactivating the second
> > > core at run time with "echo 0 >
> > > /sys/devices/system/cpu/cpu1/online"?
> > 
> > maxcpus=1 should turn off the SMP alternative and switch to UP only,
> > optimising some locks and instructions.
> 
> CPU hot unplug will do the same. But it is unlikely it accounts
> for that much performance difference.
> 
> If he used maxcpus=0 it would make sense. maxcpus=0 disables
> the IO-APIC which likely makes a large difference. But it should
> be actually slower.
> 
> There should be actually no difference in theory between max_cpus=1
> and hot unplug to one CPU. Might be some bug.

Or thermal effect.  I'd expect that behaviour with bad cooling.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
