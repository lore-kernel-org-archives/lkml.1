Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbZAMJRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbZAMJRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbZAMJQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:16:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47639 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756572AbZAMJQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:16:49 -0500
Date: Tue, 13 Jan 2009 09:17:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Allan Chandler <allachan@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ALLANC: Proposal to add progress records to process accounting
Message-ID: <20090113091703.566663ce@lxorguk.ukuu.org.uk>
In-Reply-To: <OFEF944F55.A27961D6-ONC825753D.001C91E6-C825753D.00252053@au1.ibm.com>
References: <OFEF944F55.A27961D6-ONC825753D.001C91E6-C825753D.00252053@au1.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> will be written for any process that hasn't written a record in a while
> (for our purposes, 24 hours is fine but it may be better to make this
> configurable).

Agreed and this sounds sensible.

> too much overhead to the context switch (that's putting it mildly).  I
> assume this would be somewhere in kernel/sched.c/context_switch() or
> kernel/sched.c/prepare_task_switch() although I haven't yet looked in great
> detail.

Are you planning to update the log based upon wall time or cpu used ?

Alan
