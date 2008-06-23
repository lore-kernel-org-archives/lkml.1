Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbYFWUHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbYFWUHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYFWUHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:07:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:59988 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbYFWUHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:07:03 -0400
Subject: Re: [patch] x86 supports NO_IRQ convention
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, hpa@zytor.com
In-Reply-To: <200806230428.20388.david-b@pacbell.net>
References: <200806221953.18849.david-b@pacbell.net>
	 <1214217751.8011.262.camel@pasglop>
	 <200806230428.20388.david-b@pacbell.net>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 06:06:31 +1000
Message-Id: <1214251591.8011.273.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 04:28 -0700, David Brownell wrote:
> On Monday 23 June 2008, Benjamin Herrenschmidt wrote:
> > NO_IRQ on x86 is 0
> 
> There is no such #define for it.
> And since zero is used for timer IRQs, it's not invalid.

I'll refer you to past discussions with Linus here. 0 is invalid to
drivers for all intend and purposes.

Cheers,
Ben.


