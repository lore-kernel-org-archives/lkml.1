Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbXLNTTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbXLNTTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbXLNTTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:19:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbXLNTTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:19:06 -0500
To: eranian@hpl.hp.com
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, paulus@samba.org,
       akpm@linux-foundation.org, gregkh@suse.de, mucci@cs.utk.edu,
       wcohen@redhat.com, robert.richter@amd.com, andi@firstfloor.org,
       eranian@gmail.com, roland@redhat.com
Subject: Re: [perfmon2] perfmon2 merge news
References: <20071119.050843.48408777.davem@davemloft.net>
	<18242.900.101842.261763@cargo.ozlabs.ibm.com>
	<20071119224845.GA27766@frankl.hpl.hp.com>
	<20071119.165313.163834190.davem@davemloft.net>
	<20071213160004.GC6740@frankl.hpl.hp.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 14 Dec 2007 14:12:17 -0500
In-Reply-To: <20071213160004.GC6740@frankl.hpl.hp.com> (Stephane Eranian's message of "Thu, 13 Dec 2007 08:00:04 -0800")
Message-ID: <y0mzlwdum3y.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stephane Eranian <eranian@hpl.hp.com> writes:

> [...]  AFAIK, there is no single call to stop T1 and wait until it
> is completely off the CPU, unless we go through the (internal)
> ptrace interface.

The utrace code supports this style of thread manipulation better
than ptrace.

- FChE
