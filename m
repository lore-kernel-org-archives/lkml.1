Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbXHEGLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbXHEGLr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 02:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXHEGLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 02:11:39 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:5694 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbXHEGLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 02:11:39 -0400
Date: Sun, 5 Aug 2007 09:11:33 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Message-ID: <20070805061133.GB15693@rhun.haifa.ibm.com>
References: <46B3A7BB.9000102@redhat.com> <20070803155035.1fb11c9a.akpm@linux-foundation.org> <200708041130.42038.ak@suse.de> <20070804093222.f0d7f3c7.akpm@linux-foundation.org> <86802c440708041045gd4a70fejf54f8532ff1a46f6@mail.gmail.com> <20070804111532.1d3936fa.akpm@linux-foundation.org> <86802c440708041202s4d165e6co701fe1c1e5c1a5ca@mail.gmail.com> <20070804225222.67fd9448.akpm@linux-foundation.org> <20070805060241.GA15693@rhun.haifa.ibm.com> <86802c440708042307u5f220c0cw3b3bd287eb82aa9c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440708042307u5f220c0cw3b3bd287eb82aa9c@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 11:07:04PM -0700, Yinghai Lu wrote:

> You just use my patch plus Andy's patch together...

Your patch does other things that in my opinion are not appropriate at
this stage for 2.6.23. I am aiming for the minimal change that will
fix the regression, and your patch should be considered for 2.6.24.

Cheers,
Muli
