Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbXD1REI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbXD1REI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbXD1REI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:04:08 -0400
Received: from www.osadl.org ([213.239.205.134]:52324 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756405AbXD1REH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:04:07 -0400
Subject: Re: 2.6.21 known regressions (v2) (for -stable team)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Meyer <thomas.mey@web.de>
In-Reply-To: <463375E5.5040108@googlemail.com>
References: <463375E5.5040108@googlemail.com>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 19:06:11 +0200
Message-Id: <1177779971.7646.271.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 18:27 +0200, Michal Piotrowski wrote:
> Subject    : Bad interaction between dynticks and amarok?
> References : http://lkml.org/lkml/2007/4/26/307
> Submitter  : Thomas Meyer <thomas.mey@web.de>
> Status     : Unknow

Michal,

I don't think this is a regression. What Thomas wanted to point out is,
that the amarok / sound device is making the positive effect of dynticks
moot, as it starts to trigger useless interrupts.

Thomas, is my interpretation correct ? Did you check, which interrupt
was increasing - i.e. was it the soundcard one ?

	tglx



