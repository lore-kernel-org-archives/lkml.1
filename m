Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZA2Cpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZA2Cpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 21:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZA2Cpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 21:45:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56191 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZA2Cpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 21:45:41 -0500
Date: Wed, 28 Jan 2009 21:45:39 -0500
From: Dave Jones <davej@redhat.com>
To: Xiaoning Ding <dingxn@ymail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: a question about p4_clockmod module on Xeon quad core
	processors
Message-ID: <20090129024539.GA17541@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Xiaoning Ding <dingxn@ymail.com>, linux-kernel@vger.kernel.org
References: <20090128210200.GA19527@redhat.com> <630240.73962.qm@web59913.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <630240.73962.qm@web59913.mail.ac4.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[please don't top-post]

On Wed, Jan 28, 2009 at 06:06:37PM -0800, Xiaoning Ding wrote:
 
 > >  > I have tried the p4-clockmod module in Linux kernel
 > > 2.6.29 on Xeon 5355 quad-core CPUs with no luck. It seems
 > > current p4-clockmod driver still cannot support Intel Quad
 > > core processors, right? 
 > >  > 
 > >  > I know I can also use acpi-cpufreq. It can only scale
 > > down the frequence from 2.67GHz to 2GHz. But I need some
 > > lower frequencies for some experiments.
 > > 
 > > p4-clockmod doesn't change the processor frequency.
 > > Because of common misconceptions like this, the user
 > > interface has been removed.
 > > 
 > > In 2.6.29, the clock modulation code is called directly
 > > from ACPI
 > > whenever thermal events indicate that throttling is
 > > necessary.
 > > 
 > Thanks for the correction. 
 > My experiments need to reduce CPU speed. However, I can only reduce the speed by about 30% (from 2.67GHz to 2GHz) with ACPI. That is not enough for the experiments. 

The ACPI P-states are nearly always correct, so you won't be
able to go below 2GHz on this system.

 > p4-clockmod has not been removed from 2.6.29. It is under the same directory as acpi-cpufreq (arch/x86/kernel/cpu/cpufreq). So I thought it was an alternative approach. But I could not get it loaded.

The driver is present, the _user interface_ has been removed.

	Dave

-- 
http://www.codemonkey.org.uk
