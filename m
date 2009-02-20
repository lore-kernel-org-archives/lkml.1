Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbZBTRmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbZBTRmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbZBTRlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:41:55 -0500
Received: from testure.choralone.org ([194.9.77.134]:50082 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbZBTRly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:41:54 -0500
Date: Fri, 20 Feb 2009 12:41:48 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Scott James Remnant <scott@canonical.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Change link order of x86 cpufreq modules
Message-ID: <20090220174148.GB9995@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Scott James Remnant <scott@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
References: <20090218182822.GA19902@srcf.ucam.org> <20090218183137.GD26802@elte.hu> <20090218183641.GA20203@srcf.ucam.org> <1235150992.6467.66.camel@quest> <20090220173637.GA1985@srcf.ucam.org> <1235151575.6467.68.camel@quest>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235151575.6467.68.camel@quest>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 05:39:35PM +0000, Scott James Remnant wrote:
 > On Fri, 2009-02-20 at 17:36 +0000, Matthew Garrett wrote:
 > 
 > > On Fri, Feb 20, 2009 at 05:29:52PM +0000, Scott James Remnant wrote:
 > > 
 > > > In fact, we've noticed severe regressions with p4-clockmod over simply
 > > > having no scaling driver at all - and are not going to built it into our
 > > > kernels.
 > > 
 > > It makes sense to have p4-clockmod from a thermal management 
 > > perspective. We should probably bump its transition latency to more than 
 > > 10ms to prevent ondemand binding to it.
 > > 
 > If that's possible; that'd be good.
 > 
 > The trouble with it is that it never seems to bring the CPU anywhere
 > near maximum performance.

This is one reason why in .30 the user interface for p4-clockmod is disabled.
It'll only get throttled when ACPI goes into OMG I'M OVERHEATING mode,
and ramp back up once it cools off.

p4-clockmod and ondemand is a recipe for fail.

	Dave

-- 
http://www.codemonkey.org.uk
