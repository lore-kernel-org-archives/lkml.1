Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbXDYAEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbXDYAEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 20:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbXDYAEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 20:04:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbXDYAEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 20:04:09 -0400
Date: Tue, 24 Apr 2007 20:03:27 -0400
From: Dave Jones <davej@redhat.com>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: William Heimbigner <icxcnika@mar.tar.cc>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] cpufreq: allow full selection of default governors
Message-ID: <20070425000327.GG22267@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Nish Aravamudan <nish.aravamudan@gmail.com>,
	William Heimbigner <icxcnika@mar.tar.cc>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0704242057430.25153@server.thyself> <20070424211253.GG23598@redhat.com> <29495f1d0704241505p62140160o52d83e383106bf8e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29495f1d0704241505p62140160o52d83e383106bf8e@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 03:05:36PM -0700, Nish Aravamudan wrote:
 > On 4/24/07, Dave Jones <davej@redhat.com> wrote:
 > > On Tue, Apr 24, 2007 at 09:03:23PM +0000, William Heimbigner wrote:
 > >  > The following patches should allow selection of conservative, powersave, and
 > >  > ondemand in the kernel configuration.
 > >
 > > This has been rejected several times already.
 > > Ondemand and conservative isn't a viable governor for all cpufreq
 > > implementations (ie, ones with high switching latencies).
 > 
 > This piques my curiosity -- some governors don't work with some
 > cpufreq implementations. Are those implementations in the kernel or in
 > userspace? If in the kernel, then perhaps there should be some
 > dependency expressed there in Kconfig between cpufreq implementation
 > and the available governors

it can't be solved that easily. powernow-k8 for example is fine to
use with ondemand on newer systems, where the latency is low.
On older models however, it isn't.

 > > Also, see the
 > > comment in the Kconfig a few lines above where you are adding this.
 > 
 > Are these governors unfixable? If

tbh, I've forgotten the original issues that caused the comment
to be placed there. Dominik ?

 > Just looking for more info -- feel free to just point me at the archives.

cpufreq-list archives are at http://lists.linux.org.uk/mailman/listinfo/cpufreq
(though only available to list members)

	Dave

-- 
http://www.codemonkey.org.uk
