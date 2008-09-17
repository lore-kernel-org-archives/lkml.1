Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbYIQQ1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbYIQQ1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYIQQ1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:27:04 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:21017 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbYIQQ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:27:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tedhg1pOXZN3AFFZLbPnYvC0enXt4R2QGfGEj0m2qzcPtKD/LkuQ8VsAWH0vOprtev
         /26Cb5Y/Eaxx3H1GIu/SVG2AYCRkSllPNzp8Whqnqtra2SwfXcfEsqNc0EKyurawmIhC
         V8eD8+2Zx8NHDXo2n3P1OrOtJSFkd2ipridL4=
Date: Wed, 17 Sep 2008 20:27:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: j_kernel@hoblitt.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080917162704.GE7309@lenovo>
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

Joshua, could you please do one more thing - boot the kernel
with "debug apic=debug nmi_watchdog=1" (among others) and
publish dmsg?

		- Cyrill -
