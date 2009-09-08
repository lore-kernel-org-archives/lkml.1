Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbZIHX1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbZIHX1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZIHX1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:27:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:48614 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbZIHX07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:26:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185466169"
Subject: Re: [Bug #13819] system freeze when switching to console
From: reinette chatre <reinette.chatre@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, "Ma, Ling" <ling.ma@intel.com>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>
In-Reply-To: <20090908161657.0f21c7fb@jbarnes-g45>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
	 <Vm51Upp4EV.A.r-D.mgBpKB@chimera>	<1252427375.14735.130.camel@rc-desk>
	 <alpine.LFD.2.01.0909080943030.7458@localhost.localdomain>
	 <1252431375.14735.139.camel@rc-desk>
	 <alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
	 <1252449461.30150.61.camel@rc-desk>  <20090908161657.0f21c7fb@jbarnes-g45>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 16:27:01 -0700
Message-Id: <1252452421.30150.65.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 16:16 -0700, Jesse Barnes wrote:

> Do you see "hardware wedged" messages in your log after using Linus's
> patch?  That's what I'd expect...  ah no I see we don't call the
> routine that requires interrupts in that path like I thought.

I can confirm that. While using this patch, when I am in X and then
switch to console and back to X there are no new messages (checked with
dmesg).

Reinette


