Return-Path: <linux-kernel-owner+w=401wt.eu-S1762574AbZATTjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762574AbZATTjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 14:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbZATTjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 14:39:10 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:37115 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbZATTjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 14:39:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=r02NLWXb6PNQFVWJto8A8qXbTHGs6KGz2eXWaqKTt1dzu33N8cNSpzporpKVcWT1M6
         FH37Z8W1DIY7XZSyWvWFLHt8bnt1jGs3P22riAiCGePD0moenQ18L65SWCz/QvA2G6um
         u9Ljds2I1ZUJ9vHny6p7Awnmi0p7Hl5ZOlRRc=
Message-ID: <567e52cd0901201139s1bd4e585o4a3af400c213d237@mail.gmail.com>
Date: Tue, 20 Jan 2009 21:39:06 +0200
From: alex <gsmdib@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: plz help fixing lirc_igorplugusb kernel module
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
It turns out that lirc_igorplugusb.c is part of the 2.6.28 kernel
(http://lkml.org/lkml/2008/9/9/13) and the bad news is that it's
broken.
--
Jan 20 19:05:33 s lirc_igorplugusb: USB remote driver for LIRC v0.1
Jan 20 19:05:33 s lirc_igorplugusb: Jan M. Hochstein
<hochstein@algo.informatik.tu-darmstadt.de>
Jan 20 19:05:33 s lirc_dev: lirc_register_plugin: sample_rate: 100
Jan 20 19:05:33 s lirc_igorplugusb[3]: Yuri M. Karelin, (c) 2007
ElMark IR remote control on usb3:3
Jan 20 19:05:33 s usbcore: registered new interface driver lirc_igorplugusb
Jan 20 19:10:00 s lircd-0.8.4[25107]: could not open config file
'/etc/lircd.conf'
Jan 20 19:10:00 s lircd-0.8.4[25107]: No such file or directory
Jan 20 19:10:00 s lircd-0.8.4[25108]: lircd(default) ready
.....
Jan 20 19:11:42 s lircd-0.8.4[25108]: accepted new client on /dev/lircd
Jan 20 19:11:42 s lirc_igorplugusb[3]: Device buffer overrun.
Jan 20 19:11:48 s lirc_igorplugusb[3]: Device buffer overrun.
Jan 20 19:11:49 s lirc_igorplugusb[3]: Device buffer overrun.
--
The problem naturally lies in the last third lines which reflect the
way kernel module reacts to key presses on remote. The very same
device works flawlessly under Win + Girder.
I'd be very thankful if someone could help me fixing the issue (or
rather if I could help fixing this issue).
