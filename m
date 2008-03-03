Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbYCCPHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbYCCPHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYCCPHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:07:43 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:52488 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753707AbYCCPHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:07:42 -0500
Date: Mon, 3 Mar 2008 10:07:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dirk Eibach <eibach@gdsys.de>
cc: akpm@linux-foundation.org, <linux-kernel@vger.kernel.org>,
       <greg@kroah.com>, <apw@shadowen.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: add sysfs configuration interface for CP2101
In-Reply-To: <47CBC465.9070909@gdsys.de>
Message-ID: <Pine.LNX.4.44L0.0803031006510.3456-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Dirk Eibach wrote:

> From: Dirk Eibach <eibach@gdsys.de>
> 
> The usb configuration data for the Silabs CP2101 usb to uart bridge 
> controller can be customized:
> - Vendor ID
> - Product ID
> - Power Descriptor
> - Release Number
> - Serial Number
> - Product Description String
> 
> Silabs provides a windows-only tool to do that.
> Since we use linux-only machines in our production-environment, we have no 
> proper way to customize the chips for our purpose.
> So I added sysfs configuration support to the linux driver.

Surely this sort of thing is better done in userspace, with libusb.

Alan Stern

