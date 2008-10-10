Return-Path: <linux-kernel-owner+w=401wt.eu-S1763008AbYJJTox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763008AbYJJTox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760916AbYJJTop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:44:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35929 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760417AbYJJTop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:44:45 -0400
Date: Fri, 10 Oct 2008 15:44:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] WARNING: at kernel/power/main.c:176
 suspend_test_finish+0x70/0x80()
In-Reply-To: <200810102134.27112.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0810101542320.2185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008, Rafael J. Wysocki wrote:

> I understood it was the mainline from the report.
> 
> Parag, could you please try to suspend without the USB drivers and see if the
> delay is still there?

Or even better, suspend with the USB drivers present, and with
CONFIG_USB_DEBUG, CONFIG_PM_SLEEP, and CONFIG_PRINTK_TIME all enabled.  
The resulting detailed timing information should pinpoint the problem.

Alan Stern

