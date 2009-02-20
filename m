Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbZBTRhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbZBTRhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759937AbZBTRgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:36:45 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35488 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150AbZBTRgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:36:44 -0500
Date: Fri, 20 Feb 2009 17:36:37 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Scott James Remnant <scott@canonical.com>
Cc: Ingo Molnar <mingo@elte.hu>, davej@codemonkey.org.uk,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Change link order of x86 cpufreq modules
Message-ID: <20090220173637.GA1985@srcf.ucam.org>
References: <20090218182822.GA19902@srcf.ucam.org> <20090218183137.GD26802@elte.hu> <20090218183641.GA20203@srcf.ucam.org> <1235150992.6467.66.camel@quest>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235150992.6467.66.camel@quest>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 05:29:52PM +0000, Scott James Remnant wrote:

> In fact, we've noticed severe regressions with p4-clockmod over simply
> having no scaling driver at all - and are not going to built it into our
> kernels.

It makes sense to have p4-clockmod from a thermal management 
perspective. We should probably bump its transition latency to more than 
10ms to prevent ondemand binding to it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
