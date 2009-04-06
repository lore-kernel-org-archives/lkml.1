Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbZDFJxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbZDFJxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZDFJxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:53:42 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:51702 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbZDFJxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:53:41 -0400
X-Greylist: delayed 2607 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2009 05:53:41 EDT
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Subject: The kernel may clear part of my vendor-specific SCSI command.
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OF437BF0D0.7661D63C-ON48257590.002E4899-48257590.00323751@sunplusct.com>
From: =?Big5?B?WXUtTWluZyBDaGFuZyCxaah8u8o=?= 
	<yuming.chang@sunplusct.com>
Date: Mon, 6 Apr 2009 17:07:46 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/04/06 ?? 05:07:46,
	Serialize complete at 2009/04/06 ?? 05:07:46
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linux developers,

I'm using CentOS 5.2(kernel-2.6.18) to control a specific USB massive 
storage
device. When I send a vendor-spcific SCSI command to the device like this:

unsigned char scsi_cmd[16];
sg_io_hdr_t io_hdr;
scsi_cmd[0] = 0xf1;
scsi_cmd[1] = 0xff;
io_hdr.cmdp = scsi_cmd;

the device receives a command with scsi_cmd[1] = 0x1f. I think the first 
of three
bits of second byte of io_hdr.cmdp are cleared by kernel.

Does anyone have some clues or hints?
I wish you can CC to my mailbox when you respond to my posting.

Regards,
Chang Yu-ming
