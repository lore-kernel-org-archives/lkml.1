Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYKCTGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYKCTGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYKCTGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:06:04 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43943 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752715AbYKCTGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:06:03 -0500
Date: Mon, 3 Nov 2008 14:05:56 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Norbert Preining <preining@logic.at>, Mattia Dongili <malattia@linux.it>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb device not showing up
In-Reply-To: <20081103153118.GA27552@gamma.logic.tuwien.ac.at>
Message-ID: <Pine.LNX.4.44L0.0811031403180.2194-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2008 linux-usb-owner@vger.kernel.org wrote:

> Hi all,
> 
> (please Cc)
> 
> I have the following problem with a disappearing or better not appearing
> device: My Sony Vaio VGN-Z11 laptop contains a HSDPA modem:
> 	USB: Bus 004 Device 002: ID 0af0:6911 Option
> which is very nicely supported by the hso kernel module (when using the
> latest hso patches for the BUG).
> 
> Interestingly this device does disappear if I cold boot into linux.
> 
> So:
> - First booting Vista, then RE-booting (not turning it off in the
>   meantime) into linux gives me that device and everything works.
> 
> - Cold-booting into Linux and the device does not show up.

What happens if you leave the modem turned off until after Linux is 
running?  If it does not show up then a usbmon trace would be helpful 
(see Documentation/usb/usbmon.txt for instructions).

Alan Stern

