Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbYKKCCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbYKKCCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 21:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYKKCCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 21:02:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:5352 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbYKKCCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 21:02:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,580,1220252400"; 
   d="scan'208";a="358508122"
Subject: Re: ACPI crash on lid close - SMP race?
From: Zhang Rui <rui.zhang@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081111013359.GA11364@srcf.ucam.org>
References: <20081110161105.GA2041@srcf.ucam.org>
	 <1226366834.15014.60.camel@rzhang-dt>
	 <20081111013359.GA11364@srcf.ucam.org>
Content-Type: text/plain
Date: Tue, 11 Nov 2008 09:59:38 +0800
Message-Id: <1226368778.15014.73.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-11 at 09:33 +0800, Matthew Garrett wrote:
> On Tue, Nov 11, 2008 at 09:27:14AM +0800, Zhang Rui wrote:
> > well, there is a bug report for this problem:
> > http://bugzilla.kernel.org/show_bug.cgi?id=11259
> 
> I'll give the noirqbalance case a go.
> 
> > and there are some bug reports for a similar problem (system crashes on
> > lid close if _DOS=1, but on a UP platform).
> > http://bugzilla.kernel.org/show_bug.cgi?id=6001#c49
> 
> I think the _DOS=1 case is somewhat different. There you'd expect 
> significantly more system BIOS code to be run, and that's going to stand 
> a much higher chance of causing unfortunate interactions with however 
> Linux has set up the graphics.
> 
oops. sorry, I mean system crashes on lid close if _DOS=0 on some UP
platform.

thanks,
rui


