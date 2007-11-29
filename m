Return-Path: <linux-kernel-owner+w=401wt.eu-S1761927AbXK2IGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761927AbXK2IGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 03:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbXK2IGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 03:06:06 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:49567 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbXK2IGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:06:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rhdcIAa6qQcUT1kktz+ASwkqOHwx7WgNUoXU5xn2y88epBxZLssgcz9Avdp9qpbtKYD5F94mhRgfCX8olMDRyYlBCyQSbK0OvTXn/trhhV3gLFqFQq5L3dQ9uSUrSZehJPZmxyQAA4IkRVQpGd4sX4zX1f+xHDa7cwwjMPkcpbI=
Message-ID: <a8e1da0711290006x4bd3cc45x1ae8dcaa9c0ab462@mail.gmail.com>
Date: Thu, 29 Nov 2007 16:06:01 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: bgsmith@bendcable.com, "BlueZ users" <bluez-users@lists.sourceforge.net>
Subject: Re: [Bluez-users] Lost connections - mouse and keyboard
Cc: "Marcel Holtmann" <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1196305426.23029.12.camel@pico>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1196009038.14897.6.camel@pico> <1196056187.4217.54.camel@aeonflux>
	 <1196305426.23029.12.camel@pico>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 11:03 AM, Brad Smith <bgsmith@bendcable.com> wrote:
>
> Thank you for the reply Marvel.  I use the gnome bluetooth client which

Marcel

> apparently does manage bluetooth devices using bluetooth-input-service.
> I  still have the problem of the devices disappearing if idle for too
> long such as when i lock the desktop or log out for  a long period.
> Sometimes I can re-enable the devices, but sometimes I cannot.  This is
> frustrating.
>
> I see a the following several times in the system log if i restart
> bluetooth:
> Nov 28 18:53:39 pico kernel: WARNING: at drivers/hid/hid-core.c:784
> implement() (Tainted: P       )
> Nov 28 18:53:39 pico kernel:
> Nov 28 18:53:39 pico kernel: Call Trace:
> Nov 28 18:53:39 pico kernel:  [<ffffffff811d8549>] hid_output_report
> +0x1c5/0x232
> Nov 28 18:53:39 pico kernel:  [<ffffffff811ddaf1>] hid_submit_ctrl
> +0x60/0x24b
> Nov 28 18:53:39 pico kernel:  [<ffffffff811dde45>] usbhid_submit_report
> +0x169/0x19e
> Nov 28 18:53:39 pico kernel:  [<ffffffff811e030b>] hiddev_ioctl
> +0x368/0x919
> Nov 28 18:53:39 pico kernel:  [<ffffffff810f54c5>] inode_has_perm
> +0x65/0x72
> Nov 28 18:53:39 pico kernel:  [<ffffffff81120c17>] __up_read+0x19/0x7f
> Nov 28 18:53:39 pico kernel:  [<ffffffff8125eecc>] do_page_fault
> +0x490/0x7e4
> Nov 28 18:53:39 pico kernel:  [<ffffffff810a7399>] do_ioctl+0x55/0x6b
> Nov 28 18:53:39 pico kernel:  [<ffffffff810a75f2>] vfs_ioctl+0x243/0x25c
> Nov 28 18:53:39 pico kernel:  [<ffffffff810a7664>] sys_ioctl+0x59/0x79
> Nov 28 18:53:39 pico kernel:  [<ffffffff8100bd45>] tracesys+0xd5/0xda
>

Does bluetooth input devices have something to do with usbhid? I don't
know, perhaps this is another problem in kernel.

Please dont mind to add lkml as cc.

Regards
dave

> Brad
>
>
>
> On Mon, 2007-11-26 at 06:49 +0100, Marcel Holtmann wrote:
> > Hi Brad,
> >
> > > I have a Logitech mouse and keyboard that use bluetooth (dinovo).  I
> > > have enabled bluetooth on this Fedora 8 system and both work well with
> > > two problems.
> > >
> > > (1) When I lock the system and return later the mouse no longer works.
> > > I have to open a terminal window and issue an hidd --connect command.
> > >
> > > (2) When I log out, both the mouse and keyboard stop working.  I have to
> > > connect a USB mouse and USB keyboard to enter the authentication
> > > information.  Once logged in the bluetooth devices usually work,
> > > although I sometimes have to issue an hidd --connect command to enable
> > > the keyboard.
> > >
> > > Any suggestions on resolving these issues would be appreciated.
> >
> > not using hidd and using bluetoothd-input-service instead is one thing.
> > For input devices to re-connect you have to have a daemon running that
> > handles this. The input service is the best way to achieve this. Check
> > the BlueZ wiki for details.
>
> -------------------------------------------------------------------------
> SF.Net email is sponsored by: The Future of Linux Business White Paper
> from Novell.  From the desktop to the data center, Linux is going
> mainstream.  Let it simplify your IT future.
> http://altfarm.mediaplex.com/ad/ck/8857-50307-18918-4
> _______________________________________________
> Bluez-users mailing list
> Bluez-users@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/bluez-users
>
>
