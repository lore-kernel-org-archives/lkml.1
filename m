Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbXJIXln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbXJIXln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbXJIXlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:41:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbXJIXle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:41:34 -0400
Date: Tue, 9 Oct 2007 19:41:25 -0400
From: Dave Jones <davej@redhat.com>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][try 2] architectural pstate driver for powernow-k8
Message-ID: <20071009234125.GB6879@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mark Langsdorf <mark.langsdorf@amd.com>,
	Andi Kleen <andi@firstfloor.org>, cpufreq@lists.linux.org.uk,
	linux-kernel@vger.kernel.org
References: <200710091446.38432.mark.langsdorf@amd.com> <p73fy0k3ve8.fsf@bingen.suse.de> <200710091543.21350.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710091543.21350.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 03:43:20PM -0500, Mark Langsdorf wrote:
 > This patch should apply cleanly to the 2.6.23-rc8-mm2 kernel.  It changes 
 > the powernow-k8 driver code that deals with 3rd generation Opteron, Phenom,
 > and later processors to match the architectual pstate driver described
 > in the AMD64 Architecture Programmer's Manual Volume 2 Chapter 18.  The
 > initial implementation of the hardware pstate driver for PowerNow!
 > used some processor-version specific features, and would not be
 > maintainable in the long term as the processor features changed.
 > This architectural driver should work on all future AMD processors.
 
Has this been tested on older implementations of powernow yet?
I'm happy to merge this and give it some time in -mm, before it
goes to mainline, but if no-one is testing on those older
opterons/turions etc then we're not going to know we regressed
until its too late.   If it hasn't been tested yet, any chance
you can scrounge some up at AMD and give it a spin just to be sure?

Thanks,

	Dave

-- 
http://www.codemonkey.org.uk
