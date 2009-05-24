Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbZEXOkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbZEXOkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 10:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZEXOkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 10:40:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45548 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752985AbZEXOkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 10:40:09 -0400
Date: Sun, 24 May 2009 10:40:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
cc: Robert Hancock <hancockrwd@gmail.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: [2.6.30-rc2] usb reset during big file transfer and ext3 error
In-Reply-To: <20090524071637.GA5487@ime.usp.br>
Message-ID: <Pine.LNX.4.44L0.0905241035380.7718-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 May 2009, [utf-8] Rogério Brito wrote:

> Resuming our earlier discussion, I got another case of weird USB
> messages here with kernel 2.6.30-rc5 (sorry, I have not yet had time to
> use anything newer).
> 
> My father has a USB (1.1, I would say, which matches what the logs say)
> stick/pen drive that, when I connect to my ECHI controller on my machine
> with an ICH5 chipset, I get:

> [ 2291.280525] sd 0:0:0:0: [sda] 256000 512-byte hardware sectors: (131 MB/125 MiB)
> [ 2291.283532] sd 0:0:0:0: [sda] Write Protect is off
> [ 2291.283539] sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
> [ 2291.283543] sd 0:0:0:0: [sda] Assuming drive cache: write through
> [ 2291.283603] PM: Adding info for No Bus:sda
> [ 2291.290517] sd 0:0:0:0: ioctl_internal_command return code = 8000002
> [ 2291.290523]    : Sense Key : 0x0 [current] 
> [ 2291.290529]    : ASC=0x0 ASCQ=0x0
> [ 2291.298513] sd 0:0:0:0: [sda] Assuming drive cache: write through
> [ 2291.298520]  sda: sda1
> [ 2291.304573] PM: Adding info for No Bus:sda1
> [ 2291.309522] sd 0:0:0:0: ioctl_internal_command return code = 8000002
> [ 2291.309527]    : Sense Key : 0x0 [current] 
> [ 2291.309533]    : ASC=0x0 ASCQ=0x0
...

> In particular, those ioctl_internal_command return code messages seem
> strange, regarding other USB devices that I have. Are they being shown
> because I have some debugging information in my kernel or are they
> abnormal?

It is abnormal, but I can't tell what the reason is without more 
information.  You should try using usbmon (see 
Documentation/usb/usbmon.txt) to trace these events.

Alan Stern

