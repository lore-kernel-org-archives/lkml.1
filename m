Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZHCTZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZHCTZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZHCTZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:25:00 -0400
Received: from th5.kapitza.ras.ru ([83.149.229.88]:56572 "EHLO ari.home"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754412AbZHCTY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:24:59 -0400
Date: Mon, 3 Aug 2009 23:24:46 +0400 (MSD)
From: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Artur Skawina <art.08.09@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: reading errors on JMicron JM20337 USB-SATA
In-Reply-To: <Pine.LNX.4.44L0.0908031021370.16132-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0908032046010.31015@nev.ubzr>
References: <Pine.LNX.4.44L0.0908031021370.16132-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  On Mon, 3 Aug 2009 at 6:25pm, Alan Stern wrote:

AS> You are correct except for the term "indefinitely".  The retries _will_
AS> stop if you wait long enough.  Unfortunately, because of all the nested
AS> retry loops in the SCSI drivers and at the application level, you may
AS> have to wait as long as half an hour.
It was a simple test, I've plugged the USB cable off after two hours, this 
is apparently not long enough:

[root ~]# time dd if=/dev/sdf of=/dev/null skip=61395120 count=1 bs=512
dd: reading `/dev/sdf': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 7550.12 s, 0.0 kB/s
dd: closing input file `/dev/sdf': Bad file descriptor

real    125m50.119s
user    0m0.000s
sys     0m0.000s

-L
