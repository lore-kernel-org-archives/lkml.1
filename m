Return-Path: <linux-kernel-owner+w=401wt.eu-S1763391AbXFEJEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763391AbXFEJEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762368AbXFEJD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:03:58 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:39028 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761928AbXFEJD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:03:57 -0400
Message-ID: <466526FA.3090506@dgreaves.com>
Date: Tue, 05 Jun 2007 10:03:54 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <htejun@gmail.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       IDE Linux <linux-ide@vger.kernel.org>, ballen@gravity.phys.uwm.edu
Subject: Re: 2.6.22-rc3 hibernate(?) disables SMART on ide
References: <46609290.5030701@dgreaves.com> <46613C53.8010205@gmail.com> <4661E6CA.1080203@dgreaves.com> <46643DE5.3080904@rtr.ca> <46644A71.7060300@dgreaves.com> <4664E3F5.9080904@rtr.ca>
In-Reply-To: <4664E3F5.9080904@rtr.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> That's odd.  Could you try that again,
> with the latest (either v7.3 or v7.4) version of hdparm
> (from sourceforge) ?

Using Debian's 7.3 via apt-get experimental - is that OK or would you like me to
compile the upstream?

2.6.21.1

cu:~# hdparm -V
hdparm v7.3
cu:~# hdparm -K1 /dev/hda

/dev/hda:
 setting drive keep features to 1 (on)
 HDIO_DRIVE_CMD(keepsettings) failed: Input/output error

dmesg:
skge eth0: Link is up at 1000 Mbps, full duplex, flow control both
hda: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
hda: drive_cmd: error=0x04 { DriveStatusError }
ide: failed opcode was: 0xef

David
