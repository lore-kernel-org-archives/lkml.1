Return-Path: <linux-kernel-owner+w=401wt.eu-S932833Ab0AFVNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab0AFVNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932440Ab0AFVNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:13:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab0AFVNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:13:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, caiqian@redhat.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Kratochvil <jkratoch@redhat.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: s390 && user_enable_single_step() (Was: odd utrace testing
	results on s390x)
In-Reply-To: Oleg Nesterov's message of  Wednesday, 6 January 2010 21:17:22 +0100 <20100106201722.GB26204@redhat.com>
References: <20100104155225.GA16650@redhat.com>
	<20100104171626.22ea2d9c@mschwide.boeblingen.de.ibm.com>
	<20100104181412.GA21146@redhat.com>
	<20100104211147.4CC94D532@magilla.sf.frob.com>
	<20100105105030.66bb8a0a@mschwide.boeblingen.de.ibm.com>
	<20100105153633.GA9376@redhat.com>
	<20100105164610.388effd3@mschwide.boeblingen.de.ibm.com>
	<20100105155913.GA10652@redhat.com>
	<20100105170301.GA13641@redhat.com>
	<20100105195818.GA20358@redhat.com>
	<20100106201722.GB26204@redhat.com>
X-Shopping-List: (1) Oblivious elevated redeemer cheater-hawks
   (2) Energetic ripping-cat depressions
   (3) Perspicacious cards
   (4) Lascivious relaxers
Message-Id: <20100106211329.DB4F5134D@magilla.sf.frob.com>
Date: Wed,  6 Jan 2010 13:13:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, with or without CONFIG_UTRACE, 6580807da14c423f0d0a708108e6df6ebc8bc83d
> is needed on s390 too, otherwise the child gets unnecessary traps.

This confuses me.  user_disable_single_step on non-current doesn't do
anything not already done by the memset in copy_thread.  Ooh, except
perhaps it does not clear PSW_MASK_PER.  Maybe that matters.  That's
the only thing I can think of.  Maybe Martin can make sense of it.


Thanks,
Roland
