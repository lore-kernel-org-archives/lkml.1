Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbXJYMGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbXJYMGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 08:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbXJYMGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 08:06:09 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:28797 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbXJYMGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 08:06:08 -0400
Date: Thu, 25 Oct 2007 08:04:38 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@osdl.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 0/5] Detect hwmon and i2c bus drivers interfering with ACPI Operation Region resources
Message-ID: <20071025120438.GJ30546@jupiter.solarsys.private>
References: <1193236319.4590.225.camel@queen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193236319.4590.225.camel@queen.suse.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas:

I recently told someone in private that ACPI vs. hwmon conflicts are the
biggest open problems for the hwmon subsystem.  Thank you (and Jean) for
doing this.

* Thomas Renninger <trenn@suse.de> [2007-10-24 16:31:59 +0200]:
> Hi,
> 
> it seems Len's test tree and Linus tree diverged a bit, at least with
> this patch set things do not apply cleanly.
> 
> Therefore I post these for discussion whether and in which kernel tree
> they should end up before doing work for nothing.
> If they are still a candidate for 2.6.24 (rather unintrusive), pls tell
> me whether and when I should base them against Len's test/release branch
> or whatever other tree.
> If not, it would be great if they can be included into the -mm tree and
> I can rebase them against this one.

Andrew has already picked this series; I vote for extended time in -mm.  On the
hwmon side, there is almost guaranteed to be fallout from this that may take
time to resolve.

> (...)

> A boot parameter acpi_enforce_resources=strict/lax/no is provided, which
> is default set to lax:
>   - strict: let conflicting drivers fail to load with an error message
>   - lax:    let conflicting driver work normal with a warning message
>   - no:     no functional change at all
> Depending on the feedback and the kind of interferences we see, this
> should be set to strict at later time.

As long as it's in -mm, you may as well default to =strict right away.  This
will force people to report.  Open the floodgates; I hope I don't drown.

Regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

