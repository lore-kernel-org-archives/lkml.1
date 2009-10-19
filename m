Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbZJSD5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbZJSD5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 23:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbZJSD5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 23:57:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690AbZJSD5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 23:57:40 -0400
Date: Sun, 18 Oct 2009 20:54:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Jones <davej@redhat.com>, Dominik Brodowski <linux@brodo.de>,
       dave.mueller@gmx.ch, linux-kernel@vger.kernel.org
Subject: Re: Fwd: [Bug 14340] New: speedstep-ich driver not working in
 2.6.31
Message-Id: <20091018205459.f94d89c5.akpm@linux-foundation.org>
In-Reply-To: <200910191418.23238.rusty@rustcorp.com.au>
References: <20091007201108.GA16813@redhat.com>
	<200910191418.23238.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009 14:18:21 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> Subject: speedstep-ich: fix error caused by 394122ab144dae4b276d74644a2f11c44a60ac5c
> 
> "[CPUFREQ] cpumask: avoid playing with cpus_allowed in speedstep-ich.c"
> changed the code to mistakenly pass the current cpu as the "processor"
> argument of speedstep_get_frequency(), whereas it should be the type of
> the processor.
> 
> (Based on patch by dave.mueller@gmx.ch, compile-tested only)
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> To: Dave Jones <davej@redhat.com>
> To: Dominik Brodowski <linux@brodo.de>
> Cc: dave.mueller@gmx.ch

administriviata:

- Please include the full URL to the bugzilla report in the changelog
  when fixing bugzilla reports.  To make it easy and reliable for people
  who troll the commits closing off reports.  I use the format:

	Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14340

- Please give the reporter a "Reported-by:".  And a beer.

