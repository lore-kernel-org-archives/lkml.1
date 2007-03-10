Return-Path: <linux-kernel-owner+w=401wt.eu-S933472AbXCJQAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472AbXCJQAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 11:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933482AbXCJQAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 11:00:09 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4208 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933472AbXCJQAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 11:00:08 -0500
Date: Sat, 10 Mar 2007 11:00:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
cc: Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.21-rc3-mm1
In-Reply-To: <200703101636.48758.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.44L0.0703101057380.23928-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Mariusz Kozlowski wrote:

> Right. Can't be 100% sure but without the patch it would have probably
> failed by now so I guess the patch is ok. Not sure how to make usb mouse
> plugging/unplugging process automatic ;-)

	echo FOO >/sys/bus/usb/drivers/usbhid/unbind

to simulate an unplug (actually, to do an unbind), and

	echo FOO >/sys/bus/usb/drivers/usbhid/unbind

to do a bind, where FOO is the name of the USB mouse device link present
in the /sys/bus/usb/drivers/usbhid directory.

Alan Stern

