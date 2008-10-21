Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbYJURyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbYJURyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYJURyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:54:14 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:59268 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbYJURyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:54:14 -0400
Message-ID: <48FE1741.1000502@freescale.com>
Date: Tue, 21 Oct 2008 12:54:09 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Kumar Gala <kumar.gala@freescale.com>
Subject: Best method for sending messages to user space?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a driver that provides services for a hypervisor that my company is
creating.  The hypervisor can send notifications to the driver via interrupts.
I want to send a message to user space whenever the driver receives one of the
interrupts.  The messages don't have any payload.

Should I be creating kobjects and using kobject_uevent(..., KOBJ_CHANGE) to send
these messages?  I want to take advantage of the standard (hotplug?) user-space
interface for this sort of thing, so that I don't need to have a custom-written
daemon running that waits on blocking ioctl calls.

-- 
Timur Tabi
Linux kernel developer at Freescale
