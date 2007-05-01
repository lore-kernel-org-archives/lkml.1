Return-Path: <linux-kernel-owner+w=401wt.eu-S1031291AbXEASk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031291AbXEASk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031296AbXEASk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:40:29 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46046 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031291AbXEASk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:40:26 -0400
X-Originating-Ip: 74.109.98.66
Date: Tue, 1 May 2007 14:40:11 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dead headers under drivers/
Message-ID: <Pine.LNX.4.64.0705011438120.22223@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  since richard's recent post reminded me, here's a list of header
files under drivers/ that absolutely no one in the entire tree is
including:

./drivers/serial/crisv10.h
./drivers/isdn/hardware/eicon/dbgioctl.h
./drivers/char/digi.h
./drivers/message/i2o/i2o_lan.h
./drivers/isdn/hardware/eicon/main_if.h
./drivers/message/fusion/lsi/mpi_inb.h
./drivers/message/fusion/lsi/mpi_log_fc.h
./drivers/video/riva/nv4ref.h
./drivers/scsi/pci2000.h
./drivers/char/drm/via_mm.h

(disclaimer:  i know some of those are already in andrew's tree, but i
thought i'd just print the entire output of the script, anyway.)

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
