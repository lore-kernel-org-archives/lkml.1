Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbZDMQfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbZDMQfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 12:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZDMQey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 12:34:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:57085 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750767AbZDMQex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 12:34:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/mpo9UxnHm/hBY1B35XEi90VLvk0LdjS6I08ydPd
	moHtc/GQSjlPLp
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mm-commits@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org>
	 <4609.1239456126@turing-police.cc.vt.edu>
	 <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 18:34:48 +0200
Message-Id: <1239640488.7866.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 09:04 -0700, Linus Torvalds wrote:

> So afaik, acpi-cpufreq.c should not use "work_on_cpu()" for that at all. 
> It should just do a smp_call_function_single().

Andrew already fixed it to use smp_call_function_single() because of
another regression.  (mysql+oltp took 10% peak throughput hit here)

	-Mike

