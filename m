Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbYKYPNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbYKYPNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYKYPNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:13:00 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33466 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbYKYPM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:12:59 -0500
Date: Tue, 25 Nov 2008 16:10:58 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, suparna@in.ibm.com,
       Zach Brown <zach.brown@oracle.com>, linux-aio@kvack.org,
       Jeff Moyer <jmoyer@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kvm aio wishlist
Message-ID: <20081125151058.GX26308@kernel.dk>
References: <492B0CDD.7080000@redhat.com> <492B2348.9090008@oracle.com> <492B2976.3010209@redhat.com> <492B3912.3030707@oracle.com> <492BC5CB.6000609@redhat.com> <20081125101923.GA28123@in.ibm.com> <492BD807.4000002@redhat.com> <20081125145949.GD14147@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125145949.GD14147@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25 2008, Ingo Molnar wrote:
> 
> * Avi Kivity <avi@redhat.com> wrote:
> 
> > Perhaps a variant of syslet, that is kernel-only, and does:
> >
> > - always allocate a new kernel stack at io_submit() time, but not a 
> >   new thread
> 
> such a N:M threading design is a loss - sooner or later we arrive to a 
> point where people actually start using it and then we want to 
> load-balance and schedule these entities.
> 
> So i'd suggest the kthread based async engine i wrote for syslets. It 
> worked well and for kernel-only entities it schedules super-fast - it 
> can do up to 20 million events per second on a 16-way box i'm testing 
> on. The objections about syslets were not related to the scheduling of 
> it but were mostly about the userspace API/ABI: you dont have to use 
> that.

Still unsure why that stuff never got anywhere. Do you have a pointer to
the latest posting?

-- 
Jens Axboe

