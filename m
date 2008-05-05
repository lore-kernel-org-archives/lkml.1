Return-Path: <linux-kernel-owner+w=401wt.eu-S1762751AbYEEWIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762751AbYEEWIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbYEEWIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:08:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:44269 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbYEEWII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:08:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,439,1204531200"; 
   d="scan'208";a="278154286"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Soren Hansen <soren@ubuntu.com>
Subject: Re: [PATCH] don't suspend/resume 8xx chips
Date: Mon, 5 May 2008 15:07:55 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
References: <200803261628.12336.jesse.barnes@intel.com> <20080327083835.GF30926@butch.linux2go.dk>
In-Reply-To: <20080327083835.GF30926@butch.linux2go.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051507.55375.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 27, 2008 1:38 am Soren Hansen wrote:
> On Wed, Mar 26, 2008 at 04:28:12PM -0700, Jesse Barnes wrote:
> > Recent testing has turned up some bugs in the new Intel suspend/resume
> > code for old, 8xx chipsets.  So for 2.6.25 it probably makes sense to
> > apply this patch, which should prevent the new code from getting called
> > on those chipsets.  We should have this fixed soon, but not in time for
> > 2.6.25 unfortunately.  Note that this patch (along with the
> > suspend/resume code in general) could use more testing.
>
> I've tested this patch on two different laptops: A Uniwill 223 and an
> IBM Thinkpad X40. Both have Intel 855 graphics. The former now suspends
> and hibernates just fine (it fails without the patch). The latter works
> both with and without the patch.

Soren, can you give the current DRM tree a try or apply the patch in 
http://cgit.freedesktop.org/mesa/drm/commit/?id=cb33133ef354b77a8cf06b16ce95a0babbe8bc6f?  
I'm hoping it'll fix the one machine that had a problem and not break the 
other. :)  I tested it on my new 855 machine and it fixes things here...

Thanks,
Jesse
