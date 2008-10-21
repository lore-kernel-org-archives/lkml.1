Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYJUNEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYJUNEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 09:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbYJUNEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 09:04:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43304 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753442AbYJUNEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 09:04:41 -0400
Date: Tue, 21 Oct 2008 14:03:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Sergio Luis" <eeeesti@gmail.com>
Cc: "Alan Cox" <alan@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: tty: usb-serial krefs - bad magic number for tty struct (188:0)
Message-ID: <20081021140359.3783f0fc@lxorguk.ukuu.org.uk>
In-Reply-To: <ce0170d90810210542p6ea65a74t4f9ac6f7702a9314@mail.gmail.com>
References: <ce0170d90810180915m10caa101ucc9e9a8a17cbb6cb@mail.gmail.com>
	<ce0170d90810191039i6c78bac1ue1e4b688d47740ff@mail.gmail.com>
	<20081021133824.292a9071@lxorguk.ukuu.org.uk>
	<ce0170d90810210542p6ea65a74t4f9ac6f7702a9314@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 09:42:47 -0300
"Sergio Luis" <eeeesti@gmail.com> wrote:

> On Tue, Oct 21, 2008 at 9:38 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> one of the problems was the tty_kref_put(tty) in
> >> usb_serial_port_work() [drivers/usb/serial/usb-serial.c], that was
> >> releasing the tty device. I removed that line and it _almost_ worked.
> >> well, it worked, but only _once_. If I stopped the daemon and tried to
> >
> > You removed a valid one not the erroneous one it seems.
> >
> > Unfortunately your bug report doesn't actually say _WHICH_ USB serial
> > driver you are using which makes it a bit hard to be sure I'm looking for
> > the right bug.
> >
> 
> The device is a Huawei E220 USB modem. What kind of info can I provide
> to help you with this? would dmesg help?

Ok thanks. Thats useful for two reasons

1. I've sent Linus a patch which I think fixes it
2. I have an E220 as well and mine now behaves

Alan
