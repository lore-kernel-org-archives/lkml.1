Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbZG3Vsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbZG3Vsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZG3Vsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:48:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44766 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZG3Vsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:48:40 -0400
Date: Thu, 30 Jul 2009 17:48:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Will Newton <will.newton@gmail.com>, dwalker@fifo99.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][patch 02/12] remove clocksource inline functions
Message-ID: <20090730214836.GB15780@infradead.org>
References: <200907291457.n6TEvDAt003701@d06av06.portsmouth.uk.ibm.com> <20090729173231.012d0b89@skybase> <87a5b0800907290836n6bb6da36tb0124e6d4f0673ea@mail.gmail.com> <20090729182754.2361631b@skybase> <28082.1248956470@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28082.1248956470@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You know that a priori because you're familiar with that code. But there's
> another use case: An idiot monkey like myself manages to break the kernel
> *again* in some part of the kernel they're totally unfamiliar with, and
> they need to discover for themselves that timekeeping.c is the only user.
> 
> (Of course, in another 5-6 years I'll probably have broken something in
> every part of the kernel and whinged at Andrew about it, and that argument
> won't apply anymore.. ;)

Andthe poor grepping monkey can be sure that everyone used the useless
wrapper exactly how?  If you want to help people with grepping rename
the method from read to clocksource_read..

