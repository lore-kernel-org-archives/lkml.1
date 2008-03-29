Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbYC2WCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbYC2WCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 18:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYC2WCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 18:02:05 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2501 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753053AbYC2WCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 18:02:04 -0400
Date: Sat, 29 Mar 2008 18:02:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: bugme-daemon@bugzilla.kernel.org, <rjw@sisk.pl>, <bunk@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: [Bug 10345] USB HID problems after resume
In-Reply-To: <47EE793C.5070105@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0803291759030.21236-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Mar 2008, Mark Lord wrote:

> Just happened again.  The machine resumed from RAM with no functioning USB.
> Still running the exact same 2.6.25-rc7 kernel as before, with the RTC conflict fixed.
> 
> WTF?

The first step in debugging this is to build a kernel with
CONFIG_USB_DEBUG and send the dmesg log following an unsuccessful
resume.  Include events from before the suspend; don't strip them out.  
If the symptoms are the same as before then you should also get a stack
dump for the ksuspend_usbd task.

Alan Stern

