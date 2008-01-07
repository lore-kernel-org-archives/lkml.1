Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYAGB7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYAGB7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 20:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYAGB7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 20:59:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:48823 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbYAGB7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 20:59:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,251,1196668800"; 
   d="scan'208";a="276237496"
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to 
	"unsupported" if wakeup feature isn't supported by a device
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0801041136490.4078-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0801041136490.4078-100000@iolanthe.rowland.org>
Content-Type: text/plain
Organization: Intel
Date: Mon, 07 Jan 2008 09:52:59 +0800
Message-Id: <1199670779.3551.7.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-04 at 11:38 -0500, Alan Stern wrote:
> On Fri, 4 Jan 2008, David Brownell wrote:
> 
> > > > This patch changes empty output to "unsupported" in order that a user knows
> > > > wakeup feature isn't supported by this device when he/she
> > > > 'cat /sys/devices/.../power/wakeup', please consider to apply,
> > > > thanks.
> > >
> > > What about simply removing "wakuep" file if wakeup is not supported?
> > 
> > It may not *stay* unsupported, so I think changing it in either
> > of those permanent ways would be confusing/misleading.
> 
> How about changing it to say "unavailable"?  That doesn't imply 
> permanence.
This should be an option.
> 
> Alan Stern
> 

