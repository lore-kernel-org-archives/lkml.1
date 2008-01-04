Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYADQih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYADQih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYADQia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:38:30 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50975 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752554AbYADQia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:38:30 -0500
Date: Fri, 4 Jan 2008 11:38:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: yi.y.yang@intel.com, <pavel@ucw.cz>, <linux-pm@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to 
 "unsupported" if wakeup feature isn't supported by a device
In-Reply-To: <20080104160933.B01D81FBAB5@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0801041136490.4078-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2008, David Brownell wrote:

> > > This patch changes empty output to "unsupported" in order that a user knows
> > > wakeup feature isn't supported by this device when he/she
> > > 'cat /sys/devices/.../power/wakeup', please consider to apply,
> > > thanks.
> >
> > What about simply removing "wakuep" file if wakeup is not supported?
> 
> It may not *stay* unsupported, so I think changing it in either
> of those permanent ways would be confusing/misleading.

How about changing it to say "unavailable"?  That doesn't imply 
permanence.

Alan Stern

