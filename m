Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbZHCOZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbZHCOZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932077AbZHCOZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:25:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47320 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755078AbZHCOZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:25:03 -0400
Date: Mon, 3 Aug 2009 10:25:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
cc: Artur Skawina <art.08.09@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: reading errors on JMicron JM20337 USB-SATA
In-Reply-To: <alpine.LFD.2.00.0908030958570.31015@nev.ubzr>
Message-ID: <Pine.LNX.4.44L0.0908031021370.16132-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009, Lev A. Melnikovsky wrote:

> AS> yes, jmicron bridges do not report errors properly and just stall pretty
> AS> much indefinitely; found out the hard way, when a disk started to develop
> My interpretation was different - the bridge firmware does not crash but 
> remains alive (it does not report the error properly but "zis iz probably 
> perfectly normal behaviour for a Vogon"). This is the Linux kernel that 
> indefinitely tries to re-read. Am I wrong?

You are correct except for the term "indefinitely".  The retries _will_
stop if you wait long enough.  Unfortunately, because of all the nested
retry loops in the SCSI drivers and at the application level, you may
have to wait as long as half an hour.

I agree that this should be fixed.  But it is a SCSI issue, not a USB 
issue.  You could try bringing it up on the linux-scsi mailing list.

Alan Stern

