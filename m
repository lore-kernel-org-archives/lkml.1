Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544Ab0AKPqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab0AKPqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 10:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530Ab0AKPqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 10:46:47 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46353 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753506Ab0AKPqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 10:46:47 -0500
Date: Mon, 11 Jan 2010 10:46:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Johannes Berg <johannes@sipsolutions.net>
cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: REGRESSION for RT2561/RT61 in 2.6.33
In-Reply-To: <1263222695.29743.1.camel@johannes.local>
Message-ID: <Pine.LNX.4.44L0.1001111045240.2873-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jan 2010, Johannes Berg wrote:

> Alan,
> 
> > The card doesn't work.  Although the firmware load appears to
> > succeed, "iwconfig wlan0" says no wireless extensions present.
> 
> You need to set CONFIG_CFG80211_WEXT (it is default y).
> 
> > The only clue I can offer is that "rmmod rt61pci" hangs in 
> > wiphy_unregister() during the wait_event() loop near the start,
> > because 
> > rdev->opencount is equal to -1.  This suggests a refcounting imbalance
> > 
> > of some sort.
> 
> Good point, that's a bug that will go away with CONFIG_CFG80211_WEXT,
> I'll send a fix.

Many thanks.  I'll test the patch and the config option tonight and
report back tomorrow.

Alan Stern

