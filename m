Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbZGHRru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbZGHRru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbZGHRro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:47:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41749 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbZGHRro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:47:44 -0400
Date: Wed, 8 Jul 2009 18:47:41 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: Introduces stepped frequency
	increase
Message-ID: <20090708174741.GA23487@srcf.ucam.org>
References: <200907081556.34682.czoccolo@gmail.com> <20090708161052.GA20951@srcf.ucam.org> <4e5e476b0907081041g5561a8b2s1bc393809a09b78b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0907081041g5561a8b2s1bc393809a09b78b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 07:41:23PM +0200, Corrado Zoccolo wrote:
> Hi Matthew,
> > Is this a measured powersaving? The ondemand model is based on the
> > assumption that the idle state is disproportionately lower in power than
> > any running state, and therefore it's more sensible to run flat out for
> > short periods of time than run at half speed for longer. Is this
> > inherently flawed, or is it an artifact of differences in your processor
> > design?
> 
> The flawed assumption is that running at doubled frequency halves the
> completion time.
> On cpus that can change the core speed without impacting the
> memory-cache bandwidth
> (i.e. the Pentium M), workloads that access lot of memory go at the
> same speed at
> maximum and minimum frequency.
> Now I see new CPUs that can flush their cache during deep idle states (Atoms),
> this aggravates the aforementioned problem, rendering the high
> frequency state much less appetible.

Do you have numbers to support this? What effect does the ramping up 
have on user-visible latency?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
