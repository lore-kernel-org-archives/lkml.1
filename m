Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbYBMSd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbYBMSd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYBMSds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:33:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54124 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069AbYBMSdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:33:47 -0500
Date: Wed, 13 Feb 2008 10:33:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Thomas, Sujith" <sujith.thomas@intel.com>
Cc: lenb@kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rui.zhang@intel.com
Subject: Re: [Bug-fix]:2.6.25-rc0 Generic thermal management [Patch 1/2]:
 validating input parameters
Message-Id: <20080213103309.81ce6d36.akpm@linux-foundation.org>
In-Reply-To: <05B550FD4BD2014E841D83547B62600802A6BA72@bgsmsx411.gar.corp.intel.com>
References: <05B550FD4BD2014E841D83547B62600802A3A1B0@bgsmsx411.gar.corp.intel.com>
	<20080211133827.16140ba0.akpm@linux-foundation.org>
	<05B550FD4BD2014E841D83547B62600802A6B2A7@bgsmsx411.gar.corp.intel.com>
	<20080212133446.a521a8bb.akpm@linux-foundation.org>
	<05B550FD4BD2014E841D83547B62600802A6BA72@bgsmsx411.gar.corp.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 16:33:10 +0530
"Thomas, Sujith" <sujith.thomas@intel.com> wrote:

> 	For time being I am attaching the patch and in the meanwhile
> I'll figure out
> a way to fix the wordwrap issues. This was what Len Brown also had
> recommended.

This patch has no changelog.  Please include the full and up-to-date
changelog with each iteration of a patch.

This patch doesn't apply.  My version of Linux has

	if (trip >= tz->trips || (trip < 0 && trip != THERMAL_TRIPS_NONE))
		return -EINVAL;

whereas yours apparently has

  	if (trip >= tz->trips ||
  	    (trip < 0 && trip != THERMAL_TRIPS_NONE))
  		return -EINVAL;

(plus other changes).

Maybe you have some other patch which predeced this one.

You apparently didn't resend "[Bug-fix]:2.6.25-rc0 Generic thermal
management:ACPI [Patch 2/2]: buildfix for CONFIG_THERMAL=n" which was also
mangled.


So please just start again.  Resend all patches, against latest mainline,
with full changelogs and appropriate cc's, in an unmangled form.

Also it would be good if you could be a bit more conventional with the
patch titling.  For this one, 

Subject: [patch 1/2] Generic thermal management: validate input parameters

would suit.  Section 14 of Documentation/SubmittingPatches has some
explanation.

Thanks.
