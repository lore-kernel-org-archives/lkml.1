Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959Ab0AGWqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0AGWqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912Ab0AGWq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:46:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab0AGWqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:46:25 -0500
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
In-Reply-To: Oleg Nesterov's message of  Thursday, 7 January 2010 18:54:46 +0100 <20100107175446.GA13300@redhat.com>
References: <20100104211147.4CC94D532@magilla.sf.frob.com>
	<20100105105030.66bb8a0a@mschwide.boeblingen.de.ibm.com>
	<20100105153633.GA9376@redhat.com>
	<20100105164610.388effd3@mschwide.boeblingen.de.ibm.com>
	<20100105155913.GA10652@redhat.com>
	<20100105170301.GA13641@redhat.com>
	<20100105195818.GA20358@redhat.com>
	<20100106201722.GB26204@redhat.com>
	<20100106211329.DB4F5134D@magilla.sf.frob.com>
	<20100107101855.13248dc2@mschwide.boeblingen.de.ibm.com>
	<20100107175446.GA13300@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20100107214821.94FF97300@magilla.sf.frob.com>
Date: Thu,  7 Jan 2010 13:48:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am confused as well. Yes, I thought about regs->psw.mask change too,
> but I don't understand why it helps..
[...]
> But. Acoording to the testing I did (unless I did something wrong
> again) this patch doesn't make any difference in this particular
> case. 6580807da14c423f0d0a708108e6df6ebc8bc83d does.

Those results are quite mysterious to me.  
I think we'll have to get Martin to sort it out definitively.


Thanks,
Roland
