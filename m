Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYL2Tyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYL2Tyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 14:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYL2Ty1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 14:54:27 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40013 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751979AbYL2Ty1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 14:54:27 -0500
Date: Mon, 29 Dec 2008 14:54:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Julia Lawall <julia@diku.dk>, <gregkh@suse.de>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 10/13] drivers/usb/gadget: use USB API functions rather
 than constants
In-Reply-To: <200812291014.49779.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0812291452580.1979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008, David Brownell wrote:

> Those functions were supposed to go into <linux/usb/ch9.h>, as
> I recall, since they weren't specific to the host side stack.
> 
> Having them added to the wrong file is surely part of why
> they've only been used by host side drivers.  :)

Would you like to write a patch moving the functions to ch9.h?  Or 
would you like to ask Julia or me to do it?

Alan Stern

