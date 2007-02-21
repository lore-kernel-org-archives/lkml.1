Return-Path: <linux-kernel-owner+w=401wt.eu-S1751335AbXBUTuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbXBUTuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXBUTuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:50:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40446 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbXBUTuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:50:23 -0500
Date: Wed, 21 Feb 2007 11:47:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <ak@suse.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/21] 2.6.19-stable review
Message-Id: <20070221114737.a09be761.akpm@linux-foundation.org>
In-Reply-To: <45DC9E1D.40805@redhat.com>
References: <20070221013619.GA30227@kroah.com>
	<45DC9E1D.40805@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007 14:31:41 -0500
Chuck Ebbert <cebbert@redhat.com> wrote:

> Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.19.5 release.
> > 
> > This will probably be the last release of the 2.6.19-stable series, so
> > if there are patches that you feel should be applied to that tree,
> > please let me know.
> > 
> > There are 21 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > to add a Signed-off-by: line to the patch, please respond with it.
> > 
> 
> What is the status of:
> 
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-simplfy-__assign_irq_vector.patch
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-handle-irqs-pending-in-irr-during-irq-migration.patch

That's mainly an Andi decision.  Let's cc him.

> They fix a serious bug that causes machines to freeze up
> or just run very slowly.
> 
> I'd like to see these in -stable if possible.

They're not even in mainline yet.
