Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbYDHPNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbYDHPNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYDHPNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:13:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:34590 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757997AbYDHPNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:13:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,624,1199692800"; 
   d="scan'208";a="313767284"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: 2.6.25-rc6 regression - hang on resume [Bug 10319]
Date: Tue, 8 Apr 2008 08:07:20 -0700
User-Agent: KMail/1.9.9
Cc: Romano Giannetti <romanol@upcomillas.es>, Tino Keitel <tino.keitel@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, suspend-devel@lists.sourceforge.net
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <1207658107.21698.17.camel@pern> <20080408144112.GA18580@srcf.ucam.org>
In-Reply-To: <20080408144112.GA18580@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804080807.20585.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 08, 2008 7:41 am Matthew Garrett wrote:
> On Tue, Apr 08, 2008 at 02:35:07PM +0200, Romano Giannetti wrote:
> > So, people with a working suspend-to-ram setup (even using the whitelist
> > in s2ram, I mean, simply calling s2ram) will discover that 2.6.25 break
> > their machine. Removing the s2ram package and suspending with
> > kernel-only machinery will work, but... well, it's not user-friendly.
>
> The assumption that a static table of VBE-based quirks can be used
> without paying attention to the capabilities of the video driver has
> always been broken, though I'll freely admit that it's all my fault in
> the first place...

That said, running vbetool from the console after resuming into it with a new 
i915 driver shouldn't kill your machine...

Romano, you say this was working for you before with the suspend/resume 
enabled i915 driver, right?  So something else must have broken?

You can run the upstream DRM modules against 2.6.24 to insulate yourself from 
anything in 2.6.25 that might have broken things...  That would be a good 
data point.

Jesse
