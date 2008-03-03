Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbYCCKEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbYCCKEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYCCKD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:03:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:50091 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbYCCKD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:03:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=w+OftBqOG0j2+PrOnCRHLPQLaOAbMhEmyOGxn8pRIUxqpFHajlBIGbEFL9Mfp0j6JBoo0EtvAgCKAdxtv+mZz2PYM7L+egqooV759zBl1lG9YFNUODT0xjcWG1L3iEVcMdxEovKZDVwRjURRv4+U9AnVzMC+FBpEfmkV4tZlMP4=
Message-ID: <cfd18e0f0803030203t5f0105a6m5433f16e6824861a@mail.gmail.com>
Date: Mon, 3 Mar 2008 11:03:56 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: SCHED_IDLE documentation
Cc: "Ingo Molnar" <mingo@elte.hu>, "Christoph Hellwig" <hch@lst.de>,
       cbe-oss-dev@ozlabs.org, "Jeremy Kerr" <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200803031031.52335.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203376368.275756.252634247263.1.gpush@pokey>
	 <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com>
	 <20080303092422.GA18281@elte.hu> <200803031031.52335.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 10:31 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 03 March 2008, Ingo Molnar wrote:
> > > * What's the difference between SCHED_IDLE and SCHED_BATCH?
> >
> > SCHED_BATCH can still have nice levels from -20 to +19, it is a modified
> > SCHED_OTHER/SCHED_NORMAL for "throughput oriented" workloads.
> >
> > SCHED_IDLE overrides the nice settings and it means a "super idle"
> > workload.
>
> Does that mean that a SCHED_IDLE task still runs some of the time if
> you have a CPU hog running on +19, or can any other process starve the
> SCHED_IDLE task?

Thanks.  That was going to be my next question!

I'm guessing that SCHED_IDLE doesn't get completely starved by a CPU
hog running nice +19, but it would still be interesting to know:
roughly how much of the CPU could the CPU_IDLE process expect to get
in that case?

> What happens if you have two SCHED_IDLE tasks on a single CPU, do they get
> equal share, or will they just run as batch jobs?

Also might be useful to add th e answer to this to the man page...

Cheers,

Michael


-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
