Return-Path: <linux-kernel-owner+w=401wt.eu-S935465AbYEUP2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935465AbYEUP2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935874AbYEUP1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:27:51 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:57349 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935851AbYEUP1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:27:48 -0400
Message-ID: <483431BE.7090707@csr.com>
Date: Wed, 21 May 2008 15:29:18 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       lchiquitto@novell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: fix deadlock in HCD code
References: <Pine.LNX.4.44L0.0805211005071.2490-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0805211005071.2490-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2008 14:29:17.0842 (UTC) FILETIME=[0D349720:01C8BB4F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> 
> The functions you are worried about (usb_hcd_link_urb_to_ep and 
> usb_hcd_unlink_urb_from_ep) are documented as requiring that interrupts 
> be disabled by their callers.  This patch isn't needed.

This requirement is the only reason the whci-hcd driver disables
interrupts.  Removing this requirement would reduce the time that
interrupts are disabled in the whci-hcd driver.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
