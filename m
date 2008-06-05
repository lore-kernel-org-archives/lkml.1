Return-Path: <linux-kernel-owner+w=401wt.eu-S1761450AbYFETHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450AbYFETHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYFETHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:07:01 -0400
Received: from waste.org ([66.93.16.53]:53443 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbYFETHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:07:00 -0400
Subject: Re: [PATCH 1/5] pagemap: Modify add_to_pagemap to use copy_to_user
	instead of put_user.
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Tuttle <ttuttle@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080605120221.c09dc274.akpm@linux-foundation.org>
References: <4ca0a85e0806050804q4c164105uc386dcae2ccd21d@mail.gmail.com>
	 <20080605120221.c09dc274.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 14:06:03 -0500
Message-Id: <1212692763.3953.196.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-05 at 12:02 -0700, Andrew Morton wrote:
> On Thu, 5 Jun 2008 11:04:21 -0400
> "Thomas Tuttle" <ttuttle@google.com> wrote:
> 
> > While fiddling with pagemap, I discovered a bug in add_to_pagemap.
> 
> so...  afaict we have some fairly significant problems in here and a
> version 2 of the patchset is in order?
> 
> If so, when preparing that patchset please do have a think about which
> of the fixes you believe should be backported into 2.6.25.x and prepare
> the patches so that those fixes come first, to ease that backporting.

For 2.6.25.x, we should probably just add a cast to the put_user dest.
Thomas?

-- 
Mathematics is the supreme nostalgia of our time.

