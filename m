Return-Path: <linux-kernel-owner+w=401wt.eu-S1763795AbXJRL0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763795AbXJRL0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726AbXJRL0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:26:01 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:60978 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756011AbXJRL0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:26:00 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Arnaud Fontaine <arnaud@andesi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: error: Eeek! page_mapcount(page) went negative! (-1) with  different process and kernels
References: <sa564176ksz.fsf@Toushirou.duckcorp.org>
	<20071016183510.GB25480@redhat.com>
	<sa5ejfu64t5.fsf@Toushirou.duckcorp.org>
Date: Thu, 18 Oct 2007 13:25:55 +0200
In-Reply-To: <sa5ejfu64t5.fsf@Toushirou.duckcorp.org> (Arnaud Fontaine's
	message of "Wed, 17 Oct 2007 01:03:02 +0200")
Message-ID: <87y7e0mzp8.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaud Fontaine <arnaud@andesi.org> writes:

>>>>>> "Dave" == Dave Jones <davej@redhat.com> writes:
>
>     Dave> Many of these that I've  seen have turned out to be a hardware
>     Dave> problem.  Try running memtest86+  on that machine for a while.
>     Dave>  It doesn't  catch all  problems, but  it will  highlight more
>     Dave> common memory faults.
>
> Hello,
>
> We ran memtest86+ before production, it  was about one month ago. Do you
> think it could come from that anyway?

I find that a lot of the time memtest does not reveal an error. Only
when you combine multiple sources or on random access do you get
errors. For example compiling a kernel while doing heavy I/O on the
disk. But that might just be me. Errors are rather random occurances.

Compiling a kernel repeadatly and multiple in parallel is usualy a
good test. If it sometimes fails to compile then it is near certain a
hardware error.

MfG
        Goswin
