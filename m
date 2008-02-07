Return-Path: <linux-kernel-owner+w=401wt.eu-S932171AbYBGQSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbYBGQSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbYBGQSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:18:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59109 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757541AbYBGQSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:18:13 -0500
Date: Thu, 7 Feb 2008 11:18:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Emelyanov <xemul@openvz.org>
cc: Duncan Sands <baldrick.bulk@free.fr>, <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][USBATM]: convert heavy init dances to kthread API
In-Reply-To: <47AACE2B.2040404@openvz.org>
Message-ID: <Pine.LNX.4.44L0.0802071116360.4128-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, Pavel Emelyanov wrote:

> > Does the kthread API guarantee that the kthread is not running until you call
> 
> It does. That's why the race, you mentioned above is impossible.

That is wrong.  The API guarantees only that the kthread is initially 
created in a non-running state.  It cannot guarantee that no other 
task will wake up the kthread before the caller does.

Alan Stern

