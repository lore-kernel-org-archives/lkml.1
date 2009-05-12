Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZELGY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZELGY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 02:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZELGYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 02:24:49 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:43792 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbZELGYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 02:24:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18953.5677.63000.658678@drongo.ozlabs.ibm.com>
Date: Tue, 12 May 2009 16:24:45 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
In-Reply-To: <1242054741.11251.279.camel@twins>
References: <20090508165219.469818319@chello.nl>
	<20090508170028.837558214@chello.nl>
	<18951.32643.749495.538351@drongo.ozlabs.ibm.com>
	<1242054741.11251.279.camel@twins>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Thanks, I missed that little detail.
> 
> Do we still want the new ioctl iteration flag?

Not sure; it might be useful sometimes, I guess.  We do need to clear
up the confusion about whether one does ioctl(fd, ..., flag) or
ioctl(fd, ..., &flag), and if the former we shouldn't be using _IOW,
as Arnd pointed out.

Paul.
