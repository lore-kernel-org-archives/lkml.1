Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbZFJNlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbZFJNlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZFJNlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:41:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47999 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbZFJNlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:41:10 -0400
Date: Wed, 10 Jun 2009 09:39:52 -0400
From: Dave Jones <davej@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 4/6] x86/cpufreq: use cpumask_copy instead of =
Message-ID: <20090610133952.GA10334@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	cpufreq@vger.kernel.org
References: <4A2835D8.6040903@kernel.org> <200906091627.45411.rusty@rustcorp.com.au> <4A2E19A7.1000302@kernel.org> <200906101350.23594.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906101350.23594.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 01:50:22PM +0930, Rusty Russell wrote:
 > On Tue, 9 Jun 2009 05:43:27 pm Yinghai Lu wrote:
 > > Rusty Russell wrote:
 > > > On Sun, 7 Jun 2009 07:23:52 am Yinghai Lu wrote:
 > > >> so later could use nr_cpumask_bits in cpumask_size when MAXSMP is used
 > > >
 > > > I have a (more ambitious) patch for this in my queue, which weans it off
 > > > this entirely:
 > > >
 > > > Subject: cpumask: avoid playing with cpus_allowed in powernow-k8.c
 > ...
 > > will be in .31?
 > 
 > Hope so, it's been in linux-next for ages.  The cpufreq maintainers seem to 
 > take a relaxed approach to patches, FWIW.

With so much of the cpumask stuff going through Ingo's trees, I've
taken the approach that it's easier to just let it continue to do so
rather than cherry picking the occasional cpufreq touching part.

	Dave

