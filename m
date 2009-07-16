Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbZGPCip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbZGPCip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 22:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbZGPCip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 22:38:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:49020 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074AbZGPCio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 22:38:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,408,1243839600"; 
   d="scan'208";a="475301000"
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
	generate events on changes
From: Zhang Rui <rui.zhang@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "corentincj@iksaif.net" <corentincj@iksaif.net>
In-Reply-To: <20090715135808.GA19054@srcf.ucam.org>
References: <1247517685-7719-1-git-send-email-mjg@redhat.com>
	 <1247574573.23871.8.camel@dax.rpnet.com>
	 <1247644518.26272.88.camel@rzhang-dt>
	 <1247646153.6248.3.camel@dax.rpnet.com>
	 <1247647105.26272.99.camel@rzhang-dt>
	 <1247649089.20241.5.camel@dax.rpnet.com>
	 <20090715135808.GA19054@srcf.ucam.org>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 10:39:34 +0800
Message-Id: <1247711974.26272.190.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 21:58 +0800, Matthew Garrett wrote:
> On Wed, Jul 15, 2009 at 10:11:29AM +0100, Richard Purdie wrote:
> 
> > So there are basically two values we're ever interested in at a given
> > point in time. The current ambient light reading and the corresponding
> > display luminance adjustment. Both of those could just be exposed as an
> > input device really?
> 
> The alternative would be hwmon, I guess.

you mean convert an ACPI ALS device to a hwmon device?

> 
> > Agreed, userspace should be where policy is decided. Having a standalone
> > module which connected the two together with a "default" policy might be
> > acceptable too though? If userspace then wants to handle things it just
> > makes sure the module is not loaded.
> 
> You want smoothing even in a default policy, and doing that well might 
> be a bit much for the kernel?
> 
sorry, I don't understand.
do you mean that there should be a default policy in the kernel?

thanks,
rui

