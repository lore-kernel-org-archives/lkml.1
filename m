Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYJUMnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYJUMnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbYJUMmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:42:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:14470 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbYJUMms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QVnyonAepl887X9Q2Myec1MMpM+N0oV/ABdy42VLUI/+yv+1qG8QEOPV9ffXl+x5C8
         my90cfUa8wNPyLBe/EE0HzBy+QFHmd4b1ktIIJJxgJzuTw0X8mMcylILHM5xwqzbBY7m
         jfTpXhWciJPhhRXp+ErZ/8L6qCURaKZxXpc6E=
Message-ID: <ce0170d90810210542p6ea65a74t4f9ac6f7702a9314@mail.gmail.com>
Date: Tue, 21 Oct 2008 09:42:47 -0300
From: "Sergio Luis" <eeeesti@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: tty: usb-serial krefs - bad magic number for tty struct (188:0)
Cc: "Alan Cox" <alan@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081021133824.292a9071@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ce0170d90810180915m10caa101ucc9e9a8a17cbb6cb@mail.gmail.com>
	 <ce0170d90810191039i6c78bac1ue1e4b688d47740ff@mail.gmail.com>
	 <20081021133824.292a9071@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 9:38 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> one of the problems was the tty_kref_put(tty) in
>> usb_serial_port_work() [drivers/usb/serial/usb-serial.c], that was
>> releasing the tty device. I removed that line and it _almost_ worked.
>> well, it worked, but only _once_. If I stopped the daemon and tried to
>
> You removed a valid one not the erroneous one it seems.
>
> Unfortunately your bug report doesn't actually say _WHICH_ USB serial
> driver you are using which makes it a bit hard to be sure I'm looking for
> the right bug.
>

The device is a Huawei E220 USB modem. What kind of info can I provide
to help you with this? would dmesg help?

Sergio.
