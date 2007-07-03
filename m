Return-Path: <linux-kernel-owner+w=401wt.eu-S1760348AbXGCVQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348AbXGCVQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXGCVQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:16:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57016 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751005AbXGCVQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:16:41 -0400
Date: Tue, 3 Jul 2007 17:16:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <20070703211227.GA28758@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0707031713530.8010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Matthew Garrett wrote:

> On Tue, Jul 03, 2007 at 05:10:08PM -0400, Alan Stern wrote:
> 
> > No, no -- you have it exactly backwards.  Removing the freezer turns 
> > STR into something _less_ like runtime suspend, because it adds the 
> > requirement that devices must not automatically be resumed when an I/O 
> > request arrives.
> 
> But that's fine - "Are we undergoing a systemwide suspend" is an easy 
> question to ask. Freezing processes instead means that most of those 
> paths will never be tested.

The question is easy to ask, but it's not so easy to figure out what
you should do if the answer is Yes.  Freezing processes instead means
that those "untested" paths -- in many, many drivers -- won't have to 
exist at all.

Alan Stern

