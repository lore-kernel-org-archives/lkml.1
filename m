Return-Path: <linux-kernel-owner+w=401wt.eu-S932347AbXHCOnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbXHCOnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762247AbXHCOni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:43:38 -0400
Received: from twin.jikos.cz ([213.151.79.26]:37545 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761787AbXHCOnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:43:37 -0400
Date: Fri, 3 Aug 2007 16:43:16 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Rogan Dawes <lists@dawes.za.net>,
       Oliver Neukum <oliver@neukum.org>, Greg KH <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Only enable autosuspend by   default on certain
 device classes
In-Reply-To: <20070803143338.GA19713@srcf.ucam.org>
Message-ID: <Pine.LNX.4.64.0708031636160.26230@twin.jikos.cz>
References: <20070803140909.GA19245@srcf.ucam.org>
 <Pine.LNX.4.44L0.0708031014160.3416-100000@iolanthe.rowland.org>
 <20070803143338.GA19713@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Matthew Garrett wrote:

> Windows will autosuspend hubs, bluetooth devices, HID devices

Hi Matthew,

are you sure about windows suspending the HID devices in runtime? I have 
never seen LEDs of USB keyboard connected to windows host to go off after 
some time of not using it.

We have been playing with runtime autosuspend of HID devices, are 
currently postponed the full support, as it turns out that many devices 
don't support this feature properly (probably due to not being tested in 
Windows).

-- 
Jiri Kosina
