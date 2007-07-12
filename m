Return-Path: <linux-kernel-owner+w=401wt.eu-S1765618AbXGLQJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765618AbXGLQJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344AbXGLQJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:09:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34974 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756868AbXGLQJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:09:06 -0400
Date: Thu, 12 Jul 2007 12:09:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <david@lang.hm>,
       Jeremy Fitzhardinge <jeremy@goop.org>, <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: [PATCH 0/2] Kexec jump: The first step to kexec
 base hibernation
In-Reply-To: <469631FA.2070405@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0707121205030.11819-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Mark Lord wrote:

> Rafael J. Wysocki wrote:
> > On Thursday, 12 July 2007 08:43, david@lang.hm wrote:
> >> On Wed, 11 Jul 2007, Jeremy Fitzhardinge wrote:
> >>
> >>> Andrew Morton wrote:
> ..
> >> 8. hibernate kernel does syspend-to-ram to put the devices into a known 
> >> safe state.
> > Again, the devices should be quiesced rather then suspended in this step.
> 
> That's just not possible.  The Hibernate kernel will not have all
> of the same device drivers as the mainline kernel.  Or at least that's
> what people have previously stated here.

It doesn't matter.  The Hibernate kernel needs to quiesce only the 
devices it has been using, since it is the only kernel to run since the 
system was started.

Alan Stern

