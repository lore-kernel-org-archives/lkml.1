Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZGBVaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZGBVaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZGBVaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:30:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57948 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbZGBVaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:30:00 -0400
Date: Thu, 2 Jul 2009 23:29:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joseph Cihula <joseph.cihula@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC v6][PATCH 3/4] intel_txt: Intel(R) TXT Sx shutdown support
Message-ID: <20090702212955.GB1419@ucw.cz>
References: <4A4ACA6B.4050705@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4ACA6B.4050705@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-06-30 19:31:07, Joseph Cihula wrote:
> Support for graceful handling of sleep states (S3/S4/S5) after an Intel(R) TXT launch.
> 
> Without this patch, attempting to place the system in one of the ACPI sleep
> states (S3/S4/S5) will cause the TXT hardware to treat this as an attack and
> will cause a system reset, with memory locked.  Not only may the subsequent
> memory scrub take some time, but the platform will be unable to enter the
> requested power state.

I believe I asked for Documentation how s3 works with txt before. As a
suspend maintainer, I believe I deserve to know. Now you are
resubmitting the patch without ccing me and without that explanation.

> Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>
> Signed-off-by: Shane Wang <shane.wang@intel.com>

NAK.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
