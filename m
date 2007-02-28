Return-Path: <linux-kernel-owner+w=401wt.eu-S1751480AbXB1GtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbXB1GtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 01:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXB1GtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 01:49:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:48207 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbXB1GtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 01:49:17 -0500
Subject: Re: Make sure we populate the initroot filesystem late enough
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: David Woodhouse <dwmw2@infradead.org>, torvalds@linux-foundation.org,
       john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Paul TBBle Hampson <Paul.Hampson@Pobox.com>
In-Reply-To: <3ac1a55a11baddefb903f24b988566fe@kernel.crashing.org>
References: <200612112059.kBBKx1j7022473@hera.kernel.org>
	 <1172448057.3971.9.camel@shinybook.infradead.org>
	 <1172518068.15970.6.camel@localhost> <20070226222724.GA13182@keitarou>
	 <1172558897.11949.43.camel@localhost.localdomain>
	 <3ac1a55a11baddefb903f24b988566fe@kernel.crashing.org>
Content-Type: text/plain
Date: Wed, 28 Feb 2007 07:43:07 +0100
Message-Id: <1172644987.11949.90.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It's most likely a red herring, lots of config changes
> make the bug go away on some kernel versions (but not
> on others); the problem is very sensitive to changes in
> memory layout.

I wouldn't be that sure ... I've had problems in the past with PMU based
cpufreq... looks like flushing all caches and hard-resetting the
processor on the fly when there can be pending DMAs might be a source of
trouble... especially on CPUs that don't have working cache flush HW
assist.

Ben.


