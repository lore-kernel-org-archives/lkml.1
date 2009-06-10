Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbZFJGWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbZFJGWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 02:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZFJGWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 02:22:24 -0400
Received: from ozlabs.org ([203.10.76.45]:41191 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbZFJGWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 02:22:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 4/6] x86/cpufreq: use cpumask_copy instead of =
Date: Wed, 10 Jun 2009 13:50:22 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org
References: <4A2835D8.6040903@kernel.org> <200906091627.45411.rusty@rustcorp.com.au> <4A2E19A7.1000302@kernel.org>
In-Reply-To: <4A2E19A7.1000302@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906101350.23594.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 05:43:27 pm Yinghai Lu wrote:
> Rusty Russell wrote:
> > On Sun, 7 Jun 2009 07:23:52 am Yinghai Lu wrote:
> >> so later could use nr_cpumask_bits in cpumask_size when MAXSMP is used
> >
> > I have a (more ambitious) patch for this in my queue, which weans it off
> > this entirely:
> >
> > Subject: cpumask: avoid playing with cpus_allowed in powernow-k8.c
...
> will be in .31?

Hope so, it's been in linux-next for ages.  The cpufreq maintainers seem to 
take a relaxed approach to patches, FWIW.

Thanks,
Rusty.
