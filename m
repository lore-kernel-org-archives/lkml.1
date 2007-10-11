Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbXJKKE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbXJKKE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbXJKKEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:04:22 -0400
Received: from twin.jikos.cz ([213.151.79.26]:47196 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbXJKKEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:04:21 -0400
Date: Thu, 11 Oct 2007 12:04:16 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: vojtech@suse.cz, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc4: oops in evdev_disconnect
In-Reply-To: <470E1272.2030300@gmail.com>
Message-ID: <Pine.LNX.4.64.0710111201130.25413@twin.jikos.cz>
References: <470E1272.2030300@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007, Jiri Slaby wrote:

> after unplugging usb logitech mouse I got:
> input: Logitech Logitech USB Optical Mouse as
> /devices/pci0000:00/0000:00:1d.3/usb5/5-2/5-2:1.0/input/input10
> input: USB HID v1.11 Mouse [Logitech Logitech USB Optical Mouse] on
> usb-0000:00:1d.3-2
> usb 5-2: USB disconnect, address 6
> Unable to handle kernel paging request at 0000000000100100 RIP:
>  [<ffffffff803b6ac4>] evdev_disconnect+0xb4/0xf0

Could you by any chance try to reproduce this when Dmitry's patches 
implementing proper locking in the input subsystem are applied? Andrew's 
tree has them pulled through git-input.patch for example.

Thanks,

-- 
Jiri Kosina
