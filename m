Return-Path: <linux-kernel-owner+w=401wt.eu-S1761280AbXGEOOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280AbXGEOOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760124AbXGEOOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:14:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55310 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759271AbXGEOOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:14:16 -0400
Date: Thu, 5 Jul 2007 10:14:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Adrian Bunk <bunk@stusta.de>
cc: Paul Mackerras <paulus@samba.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] The big suspend mess
In-Reply-To: <20070704221952.GM3492@stusta.de>
Message-ID: <Pine.LNX.4.44L0.0707051013170.3728-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007, Adrian Bunk wrote:

> IMHO the suspend code is currently way too much of a moving target which 
> results in this mess.
> 
> The correct order seems to be:
> 1. agree on what the suspend code as a whole should look like
> 2. implement this
> 3. fix ALL drivers to work at least as good as they do today
> 4. get it tested in -mm
> 5. fix all bugs people run into
> 6. submit it for inclusion in Linus' tree
> 7. quickly work on the most likely big amount of bug reports
> 
> Step 1 is the most important one - evolving code is often something 
> good, but in this case with different people trying to evolve the 
> suspend code in different directions it simply results in a big mess.

Isn't Step 1 exactly what we are in the midst of right now?

Alan Stern

