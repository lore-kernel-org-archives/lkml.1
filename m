Return-Path: <linux-kernel-owner+w=401wt.eu-S1765573AbXFRU3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765573AbXFRU3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763626AbXFRU3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:29:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763683AbXFRU3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:29:11 -0400
Date: Mon, 18 Jun 2007 16:28:49 -0400
From: Dave Jones <davej@redhat.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, davej@codemonkey.org.uk
Subject: Re: cpufreq: too long transition latency
Message-ID: <20070618202849.GA27690@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Meelis Roos <mroos@linux.ee>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	davej@codemonkey.org.uk
References: <Pine.SOC.4.64.0706182315470.11208@math>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0706182315470.11208@math>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 11:23:27PM +0300, Meelis Roos wrote:
 > I have the following messages in my laptops dmesg
 > 
 > ondemand governor failed to load due to too long transition latency
 > 
 > and activating ondemand governor fails. This seems to be introduced in 
 > 2.6.22-rc* series - I seem to remember that 2.6.21 was OK but can not 
 > test at the moment.
 > 
 > Laptop is IBM X20, 440BX chipset, Pentium III (Coppermine). Config and 
 > full dmesg are below.

speedstep-ich takes a long time to transition.
as ondemand can change speeds frequently, this can cause unacceptable
slowdowns, so it prevents itself from being used.

	Dave

-- 
http://www.codemonkey.org.uk
