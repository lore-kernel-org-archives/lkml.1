Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbZLPTuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbZLPTuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZLPTun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:50:43 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51546 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751473AbZLPTum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:50:42 -0500
Date: Wed, 16 Dec 2009 14:50:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: Roger Oksanen <roger.oksanen@cs.helsinki.fi>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
Subject: Re: e100 REGRESSION in 2.6.32
In-Reply-To: <alpine.WNT.2.00.0912160938450.5316@jbrandeb-desk1.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.0912161447260.2643-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009, Brandeburg, Jesse wrote:

> copied the netdev mailing list.

Oops.  With all the other CC's I forgot to include netdev.  Shame, 
shame...

>  Alan thanks for the report, I wonder if 
> you can revert 98468efddb101f8a29af974101c17ba513b07be1 and see if that 
> fixes it?

It does indeed.  Thanks for the quick response.

> Roger on the To: line made that change, which may have broken e100 for 
> your system.

It looks simple enough, but obviously something is wrong with it.

Alan Stern

