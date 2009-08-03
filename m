Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbZHCHTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbZHCHTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 03:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZHCHTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 03:19:32 -0400
Received: from th5.kapitza.ras.ru ([83.149.229.88]:37109 "EHLO ari.home"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752291AbZHCHTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 03:19:31 -0400
Date: Mon, 3 Aug 2009 11:19:33 +0400 (MSD)
From: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
To: Artur Skawina <art.08.09@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: reading errors on JMicron JM20337 USB-SATA
In-Reply-To: <4A759CAB.9010002@gmail.com>
Message-ID: <alpine.LFD.2.00.0908030958570.31015@nev.ubzr>
References: <alpine.LFD.2.00.0908020135100.15267@nev.ubzr> <4A759CAB.9010002@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On Sun, 2 Aug 2009 at 6:03pm, Artur Skawina wrote:

AS> Lev A. Melnikovsky wrote:
AS> > I have read through a year old thread on "JMicron JM20337 USB-SATA data
AS> > corruption bugfix" and it seems here's another aspect of the same
AS> > problem. The SATA disk has genuine errors (bad sectors, just in case: I
AS> > am not going to use it but to recover some data from it). Unfortunately
AS> > when a bad block is read no error is returned, instead a caller is
AS> > blocked indefinitely (until the USB cable is removed). The system log is
AS> > filled with repetitive
AS> > 
AS> > sd 3:0:0:0: [sdf] Sense Key : 0x0 [current]
AS> > sd 3:0:0:0: [sdf] ASC=0x0 ASCQ=0x0
AS> 
AS> yes, jmicron bridges do not report errors properly and just stall pretty
AS> much indefinitely; found out the hard way, when a disk started to develop
My interpretation was different - the bridge firmware does not crash but 
remains alive (it does not report the error properly but "zis iz probably 
perfectly normal behaviour for a Vogon"). This is the Linux kernel that 
indefinitely tries to re-read. Am I wrong?

AS> What did work for my case was to copy the data from the disk and every 
AS> time the process stalled turn off power to the sata drive for a few 
AS> seconds (leaving the bridge connected). The bridge in most cases 
AS> recovered and a bit more data got off the drive.
My nerve is too weak to touch ground/power until the data line is 
disconnected. Running -rc1 seems not so dangerous...

-L
