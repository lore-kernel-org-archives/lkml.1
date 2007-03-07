Return-Path: <linux-kernel-owner+w=401wt.eu-S1422692AbXCGJso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422692AbXCGJso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422694AbXCGJso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:48:44 -0500
Received: from www.osadl.org ([213.239.205.134]:52526 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422692AbXCGJso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:48:44 -0500
Subject: Re: How to distinguish original kernel vs -rt kernel
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
In-Reply-To: <45EE8829.4060304@bull.net>
References: <45EE8829.4060304@bull.net>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 10:54:50 +0100
Message-Id: <1173261291.24738.581.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 10:38 +0100, Pierre Peiffer wrote:
> In fact, I'm facing the problem of HRTIMER_ABS/REL being renamed to 
> HRTIMER_MODE_ABS/REL with patch -rt. Is there a reason of this ?
> 
> Does anyone have an objection of keeping it the same (let's say 
> HRTIMER_ABS/REL) in kernel -rt ?

It is HRTIMER_MODE_xx in mainline as of 2.6.21-rc1. -rt kernels are
always a bit ahead of time. :)

	tglx




