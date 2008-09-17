Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbYIQNAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbYIQNAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 09:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYIQM7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 08:59:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:32960 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYIQM7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 08:59:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FWbUXaODl4Npex4Q5pUZkWbfHpZ70l1K2YJYXVv46Q/Pl1rhGi7/wPYPBgKfXQGpXp
         ScUkf7Lc2Rv2lyAe84qAx+I4B2BYVTFxzYkXwP9vdVB+m+WvGwPXh5gOnsE41WpJtsxr
         wQN8o89iarB74FkEKj3zd7SOdem66mJosAz/M=
Date: Wed, 17 Sep 2008 16:59:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: j_kernel@hoblitt.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080917125950.GA7309@lenovo>
References: <20080917024312.GA23209@hoblitt.com> <20080917071357.GA7455@lenovo> <20080917092058.GB23209@hoblitt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917092058.GB23209@hoblitt.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[j_kernel@hoblitt.com - Tue, Sep 16, 2008 at 11:20:58PM -1000]
| On Wed, Sep 17, 2008 at 11:13:57AM +0400, Cyrill Gorcunov wrote:
| > Joshua, could you please attach ACPI tables dump to the bugzilla entry (~300K)?
| 
| Done but I was unable to extract the DSDT table as described in the
| instructions.
| 
| #  acpixtract DSDT < acpidump.asc           
| Could not open DSDT
| 
| Cheers,
| 
| -J
| 
| --
| 

As far as I can see there is no really issue in ACPI configuration,
at least on apic side...

Evetually nmi_watchdog=2 does work right? Though it's not
good that we've got 8259 spurious interrupt. Hmm...

		- Cyrill -
