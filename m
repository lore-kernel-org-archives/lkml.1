Return-Path: <linux-kernel-owner+w=401wt.eu-S1759810AbXLTKP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbXLTKP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 05:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbXLTKPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 05:15:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44379 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbXLTKPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 05:15:51 -0500
Date: Thu, 20 Dec 2007 10:15:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pierre Savary <pierre.savary@kerlink.fr>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: syscall in a module
Message-ID: <20071220101532.GA31128@flint.arm.linux.org.uk>
References: <20071220091605.GC7921@flint.arm.linux.org.uk> <000401c842ea$5aef1ea0$10cd5be0$@savary@kerlink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000401c842ea$5aef1ea0$10cd5be0$@savary@kerlink.fr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 10:26:08AM +0100, Pierre Savary wrote:
> In fact I have a part (/dev/mmcblk0p5) that I want share with USB gadget
> (g_file_storage). But if USB is not connect to a PC, I want that this part
> was mounted on my board. An I want unmount this part when the board is
> plugged on a PC.
> So I need to mount and unmount partition in this module.

Arrange for the USB subsystem to send a uevent, which can then be picked
up by userspace to issue the correct command to mount or unmount the
partition.
