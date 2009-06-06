Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZFFXlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZFFXlD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 19:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbZFFXky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 19:40:54 -0400
Received: from ozlabs.org ([203.10.76.45]:37978 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZFFXky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 19:40:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] cpumask: alloc blank cpumask left over
Date: Sun, 7 Jun 2009 09:10:49 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4A2835D8.6040903@kernel.org> <alpine.LFD.2.01.0906051026030.6847@localhost.localdomain> <4A295C76.3050900@kernel.org>
In-Reply-To: <4A295C76.3050900@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906070910.50202.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jun 2009 03:27:10 am Yinghai Lu wrote:
> It seems we could remove that FIXME now.
> cpumask_size is referred rather later.

No!!

First we need to get rid of all the old cpumask ops which assume NR_CPUS bits,
at least for any core or x86 code (the only arch which currently sets 
CONFIG_CPUMASK_OFFSTACK).

Rusty.
