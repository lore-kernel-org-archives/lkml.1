Return-Path: <linux-kernel-owner+w=401wt.eu-S1751417AbXB0HEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbXB0HEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 02:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbXB0HEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 02:04:22 -0500
Received: from gate.crashing.org ([63.228.1.57]:51655 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbXB0HEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 02:04:21 -0500
Subject: Re: Make sure we populate the initroot filesystem late enough
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul TBBle Hampson <Paul.Hampson@Pobox.com>
Cc: john stultz <johnstul@us.ibm.com>, torvalds@linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20070226222724.GA13182@keitarou>
References: <200612112059.kBBKx1j7022473@hera.kernel.org>
	 <1172448057.3971.9.camel@shinybook.infradead.org>
	 <1172518068.15970.6.camel@localhost>  <20070226222724.GA13182@keitarou>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 07:48:16 +0100
Message-Id: <1172558897.11949.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > I've not been able to reproduce it since, but I know others (BCC'ed on
> > this note) have seen it and might prod them to come forth with details
> > (and broken .config files)
> 
> In my case, disabling CPU_FREQ_PMAC made the failure go away.
> After reverting this patch, CPU_FREQ_PMAC is once again operating
> successfully, so far.

Hrm.. which cpufreq method is used on both your machines ? If it's the
one involving the PMU, it does involve a full hard reset of the
processor (with appropriate cache flushes etc...), maybe something's
going wrong in that area....

Ben.


