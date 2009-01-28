Return-Path: <linux-kernel-owner+w=401wt.eu-S1760169AbZA1VCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbZA1VCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZA1VCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:02:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60435 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbZA1VCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:02:02 -0500
Date: Wed, 28 Jan 2009 16:02:00 -0500
From: Dave Jones <davej@redhat.com>
To: Xiaoning Ding <dingxn@ymail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: a question about p4_clockmod module on Xeon quad core
	processors
Message-ID: <20090128210200.GA19527@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Xiaoning Ding <dingxn@ymail.com>, linux-kernel@vger.kernel.org
References: <603382.20833.qm@web59902.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <603382.20833.qm@web59902.mail.ac4.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 12:17:25PM -0800, Xiaoning Ding wrote:
 > Hi list,
 > 
 > I have tried the p4-clockmod module in Linux kernel 2.6.29 on Xeon 5355 quad-core CPUs with no luck. It seems current p4-clockmod driver still cannot support Intel Quad core processors, right? 
 > 
 > I know I can also use acpi-cpufreq. It can only scale down the frequence from 2.67GHz to 2GHz. But I need some lower frequencies for some experiments.

p4-clockmod doesn't change the processor frequency.
Because of common misconceptions like this, the user interface has been removed.

In 2.6.29, the clock modulation code is called directly from ACPI
whenever thermal events indicate that throttling is necessary.

	Dave

-- 
http://www.codemonkey.org.uk
