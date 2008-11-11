Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbYKKBaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbYKKBaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 20:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYKKB3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 20:29:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:38767 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbYKKB3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 20:29:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,580,1220252400"; 
   d="scan'208";a="74035483"
Subject: Re: ACPI crash on lid close - SMP race?
From: Zhang Rui <rui.zhang@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081110161105.GA2041@srcf.ucam.org>
References: <20081110161105.GA2041@srcf.ucam.org>
Content-Type: text/plain
Date: Tue, 11 Nov 2008 09:27:14 +0800
Message-Id: <1226366834.15014.60.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

well, there is a bug report for this problem:
http://bugzilla.kernel.org/show_bug.cgi?id=11259

and there are some bug reports for a similar problem (system crashes on
lid close if _DOS=1, but on a UP platform).
http://bugzilla.kernel.org/show_bug.cgi?id=6001#c49

but unfortunately we haven't made any progress in this issue. :(

thanks,
rui

On Tue, 2008-11-11 at 00:11 +0800, Matthew Garrett wrote:
> If the _DOS flag on my HP 2510p is set to 0 (ie, signal OS when screen 
> notification is requested, don't change automatically) then it'll crash 
> on random lid open/closes. The trace generally makes little sense and 
> depends on the kernel version and phase of the moon. I'd ignored this as 
> firmware brokenness up until lately, but since having _DOS set to 0 is 
> the only way to get a notification when the display switch key is 
> pressed on this machine I'd be interested in fixing it properly. 
> 
> Unfortunately, I've got no real idea what on earth is going on. The only 
> clue I've found so far is that booting with maxcpus=1 leaves it working 
> perfectly. What parts of the ACPI stack could be triggering this?
> 

