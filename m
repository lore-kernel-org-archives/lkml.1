Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYIEDcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYIEDcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYIEDb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:31:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60045 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbYIEDbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:31:55 -0400
Date: Thu, 4 Sep 2008 21:26:13 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, bgmerrell@novell.com,
       hirofuchi@users.sourceforge.net, linux-kernel@vger.kernel.org,
       usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-Id: <20080904212613.124d3656.zaitcev@redhat.com>
In-Reply-To: <20080904214802.GO2772@parisc-linux.org>
References: <20080903191023.GF2772@parisc-linux.org>
	<Pine.LNX.4.44L0.0809031544020.3559-100000@iolanthe.rowland.org>
	<20080904214802.GO2772@parisc-linux.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 15:48:02 -0600, Matthew Wilcox <matthew@wil.cx> wrote:

> > It's referred to as SetPortFeature(PORT_RESET) in section 11.24.2.13;  
> > the request is actually sent to the device's upstream hub.
> 
> Mmm.  In this case, we don't have an upstream hub.  The vhci-hcd driver
> is on the host and sends URBs across the network where they're received
> by the stub driver.  The stub then sends them to the exported device.

I'm sorry I'm barging into the conversation, but a HC without a
root hub is rather shocking. One would think it easier to emulate
a root hub with one port in HCD than to teach the whole stack about
such thing as a hubless HC.

-- Pete
