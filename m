Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbXGCVKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbXGCVKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbXGCVKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:10:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53214 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750730AbXGCVKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:10:08 -0400
Date: Tue, 3 Jul 2007 17:10:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <20070703202329.GA27927@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0707031708080.8010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Matthew Garrett wrote:

> See the start of this thread. It's just not clear what the freezer buys 
> us - removing it gets rid of a load of subtle issues and complexity, and 
> turns system suspend into something that looks more like runtime 
> suspend (which might then encourage people to get runtime suspend 
> right...)

No, no -- you have it exactly backwards.  Removing the freezer turns 
STR into something _less_ like runtime suspend, because it adds the 
requirement that devices must not automatically be resumed when an I/O 
request arrives.

Alan Stern

