Return-Path: <linux-kernel-owner+w=401wt.eu-S1764380AbXGYHXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764380AbXGYHXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758924AbXGYHXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:23:45 -0400
Received: from eazy.amigager.de ([213.239.192.238]:60633 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbXGYHXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:23:44 -0400
Date: Wed, 25 Jul 2007 09:23:43 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc1: USB hard disk broken
Message-ID: <20070725072343.GA3483@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just tried 2.6.23-rc1 and shortly after the boot my external USB hard
disk went mad.

I all started with these kernel messages:

kern.info: usb 1-6: USB disconnect, address 5
kern.info: sd 4:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
kern.warn: end_request: I/O error, dev sdb, sector 680000479
kern.alert: I/O error in filesystem ("dm-2") meta-data dev dm-2 block 0x6c7fa20
("xfs_trans_read_buf") error 5 buf count 8192

The full kernel log can be found here:

http://tikei.de/kernel.log

And the config:

http://tikei.de/kernel.config

Needless to say that it all worked fine with 2.6.22.

Regards,
Tino
