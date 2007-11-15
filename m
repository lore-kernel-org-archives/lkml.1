Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbXKOO5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbXKOO5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 09:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbXKOO5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 09:57:45 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:22084 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbXKOO5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 09:57:45 -0500
Message-ID: <1618816c0711150657p35744001ic6d4ea22d5651a63@mail.gmail.com>
Date: Thu, 15 Nov 2007 07:57:44 -0700
From: "Raymano Garibaldi" <raymano@faunos.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.23-1] [USB Mass Storage] [USB_PERSIST] Losing mounted USB storage after resume
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there a way/patch that would revert the USB mass storage
suspend/resume behavior to the way things worked on and prior to
kernel 2.6.21?

The problem is mounting a usb drive, suspending while mounted,
detaching the usb drive during suspend, reattaching usb drive during
suspend before resume, and resuming.

In this case the mount is lost and the drive has to be remounted after
resume. If the device remains attached while the computer is
suspended, USB_PERSIST works as expected and the device remains
mounted when the computer resumes. Kernel 2.6.21-x would leave the
mount point intact whether the device was left attached or was
detached and reattached while the computer was suspend.

We need this functionality particularly in read-only live USB distros.
In this case the USB device is read-only and can not change while the
computer is suspended even if it gets detached and is reattached
before resume.

Thank you,
Raymano G.
