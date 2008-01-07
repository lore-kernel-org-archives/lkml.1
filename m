Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYAGCB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYAGCB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 21:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYAGCBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 21:01:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:25403 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbYAGCBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 21:01:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,251,1196668800"; 
   d="scan'208";a="317003407"
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to
	"unsupported" if wakeup feature isn't supported by a device
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Olivier Galibert <galibert@pobox.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080104165214.GA30672@dspnet.fr.eu.org>
References: <20080104160933.B01D81FBAB5@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <Pine.LNX.4.44L0.0801041136490.4078-100000@iolanthe.rowland.org>
	 <20080104165214.GA30672@dspnet.fr.eu.org>
Content-Type: text/plain
Organization: Intel
Date: Mon, 07 Jan 2008 09:55:23 +0800
Message-Id: <1199670923.3551.10.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-04 at 17:52 +0100, Olivier Galibert wrote:
> On Fri, Jan 04, 2008 at 11:38:29AM -0500, Alan Stern wrote:
> > How about changing it to say "unavailable"?  That doesn't imply 
> > permanence.
> 
> How about not changing a userland-visible interface gratuitously?
"empty" can't tell a user the state of wakeup of a device, so it is
necessary to change it.
> 
>   OG.
> 

