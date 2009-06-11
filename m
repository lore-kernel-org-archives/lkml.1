Return-Path: <linux-kernel-owner+w=401wt.eu-S1761732AbZFKCe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761732AbZFKCe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 22:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZFKCeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 22:34:50 -0400
Received: from ozlabs.org ([203.10.76.45]:59637 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbZFKCeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 22:34:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: [PATCH 4/6] x86/cpufreq: use cpumask_copy instead of =
Date: Thu, 11 Jun 2009 12:04:47 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Yinghai Lu" <yinghai@kernel.org>, "Avi Kivity" <avi@redhat.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Dave Jones" <davej@redhat.com>, cpufreq@vger.kernel.org
References: <4A2835D8.6040903@kernel.org> <200906101552.17397.rusty@rustcorp.com.au> <6453C3CB8E2B3646B0D020C1126132730362099D@sausexmb4.amd.com>
In-Reply-To: <6453C3CB8E2B3646B0D020C1126132730362099D@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906111204.48441.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009 05:12:16 am Langsdorf, Mark wrote:
> > powernow_k8_target is problematic: it grabs a mutex.  cpufreq
> > people, is this called often?
>
> Yes.  It's the function that makes a frequency change
> happen, so 5+ times per second per core isn't
> unreasonable.

Right, so we need to revisit this.  I'll leave it for the moment and put it on 
my TODO list.

Thanks,
Rusty.
