Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbZGHQLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbZGHQLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760324AbZGHQK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:10:56 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40882 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760208AbZGHQKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:10:54 -0400
Date: Wed, 8 Jul 2009 17:10:52 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: Introduces stepped frequency
	increase
Message-ID: <20090708161052.GA20951@srcf.ucam.org>
References: <200907081556.34682.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907081556.34682.czoccolo@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 03:56:33PM +0200, Corrado Zoccolo wrote:
> The patch introduces a new sysfs tunable cpufreq/ondemand/freq_step,
> as found in conservative governor, to chose the frequency increase step,
> expressed as percentage (default = 100 is previous behaviour).
> 
> This allows fine tuning powersaving on mobile CPUs, since smaller steps will allow to:
> * absorb punctual load spikes
> * stabilize at the needed frequency, without passing for more power consuming states, and

Is this a measured powersaving? The ondemand model is based on the 
assumption that the idle state is disproportionately lower in power than 
any running state, and therefore it's more sensible to run flat out for 
short periods of time than run at half speed for longer. Is this 
inherently flawed, or is it an artifact of differences in your processor 
design?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
