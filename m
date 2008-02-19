Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYBSAOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYBSAOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbYBSAOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:14:40 -0500
Received: from serenity.mcc.ac.uk ([130.88.200.93]:50751 "EHLO
	serenity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbYBSAOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:14:39 -0500
Message-ID: <47BA1FE7.4050905@gentoo.org>
Date: Tue, 19 Feb 2008 00:16:39 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20080212)
MIME-Version: 1.0
To: kernel.org@spam.bounceme.net
CC: linux-kernel@vger.kernel.org
Subject: Re: Help writing my first USB driver ( no user space code needed
 )
References: <4001cab67e57fde89217db5cc31f921c@lublink.net>
In-Reply-To: <4001cab67e57fde89217db5cc31f921c@lublink.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-UoM: Scanned by the University Mail System. See http://www.itservices.manchester.ac.uk/email/filtering/information/ for details.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel.org@spam.bounceme.net wrote:
> I am trying to write a device driver for a USB device that is not currently
> supported by Linux. Trouble is all the examples I have found so far (
> usb-skel.c and others ) give an example of a driver that is a middle man
> between a userspace application and the device. So there are no examples on
> how to actually send the data to the device.
> 
> In my case, the device I am using simply uses the machine it is connected
> to as an internet connection. The driver should send/receive data from the
> device and allow the device to go and make TCP connections to the internet.

You probably want to do this in userspace using libusb. I would be 
surprised if there is any sane way of creating and managing TCP 
connections from inside the kernel.

Daniel
