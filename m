Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbYBRTOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbYBRTOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYBRTOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:14:43 -0500
Received: from torrie.malaiwah-hosting.info ([72.55.141.253]:39561 "EHLO
	mail.lublink.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbYBRTOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:14:42 -0500
MIME-Version: 1.0
Date: Mon, 18 Feb 2008 13:47:45 -0500
To: linux-kernel@vger.kernel.org
Subject: Help writing my first USB driver ( no user space code needed )
Reply-To: kernel.org@spam.bounceme.net
Message-ID: <4001cab67e57fde89217db5cc31f921c@lublink.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
From: kernel.org@spam.bounceme.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

I am trying to write a device driver for a USB device that is not currently
supported by Linux. Trouble is all the examples I have found so far (
usb-skel.c and others ) give an example of a driver that is a middle man
between a userspace application and the device. So there are no examples on
how to actually send the data to the device.

In my case, the device I am using simply uses the machine it is connected
to as an internet connection. The driver should send/receive data from the
device and allow the device to go and make TCP connections to the internet.

( The device is intelligent ).

Are there any examples that are available that would help me get started on
this?

Basically the USB device sends plain text with words like "connect, send,
recv, close" and the driver needs to make connections, send/receive data
(TCP ) and close the connection.

Thanks,

David

