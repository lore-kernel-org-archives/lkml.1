Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbXLDM0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbXLDM0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXLDM0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:26:30 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:5304 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbXLDM03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:26:29 -0500
Subject: Re: [s390] build failure
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <E1IzWVI-0002zO-Ff@faramir.fjphome.nl>
References: <200711281127.30051.elendil@planet.nl>
	 <1196247798.15829.4.camel@localhost> <E1IzWVI-0002zO-Ff@faramir.fjphome.nl>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 04 Dec 2007 13:26:26 +0100
Message-Id: <1196771186.9441.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-04 at 13:03 +0100, Frans Pop wrote:
> Martin Schwidefsky wrote:
> > On Wed, 2007-11-28 at 11:27 +0100, Frans Pop wrote:
> >> arch/s390/kernel/built-in.o: In function `cleanup_io_leave_insn':
> >> diag.c:(.text+0xc29a): undefined reference to `preempt_schedule_irq'
> >> make[2]: *** [.tmp_vmlinux1] Error 1
> > 
> > This is fixes by a patch from Christian:
> >       [S390] Fix compile error on 31bit without preemption
> > 
> > You can get the latest s390 patches by pulling from
> > git://git390.osdl.marist.edu/pub/scm/linux-2.6.git fixes
> 
> Any reason this has not been pushed into mainline yet? The fix missed -rc4
> because of that...

The a final s390 please pull for 2.6.24 will be sent in the next few
days. The preempt fix for 31 bit has been added to the repository by
Christian shortly after I sent the last please pull. I want to avoid to
sent too many of them.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


