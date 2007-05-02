Return-Path: <linux-kernel-owner+w=401wt.eu-S1766824AbXEBTvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766824AbXEBTvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766847AbXEBTvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:51:50 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60995 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766852AbXEBTvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:51:48 -0400
X-Originating-Ip: 72.143.66.196
Date: Wed, 2 May 2007 15:51:25 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: marcel@holtmann.org
Subject: dead CONFIG variables:  net/bluetooth/
Message-ID: <Pine.LNX.4.64.0705021548050.16336@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  this example is somewhat misleading as some of the bluetooth source
(unfortunately) uses variables that start with the "CONFIG_" prefix
that have nothing to do with the Kconfig files.  for clarity, this is
the sort of thing that should be avoided.

  obviously, what's happening here is nothing but a bunch of explicit
debugging variables, but it would still be better if they were renamed
to not have that "CONFIG_" prefix (unless, of course, debugging
entries for them are added to the appropriate Kconfig files).

$ ../dead_config.sh net/bluetooth
========== BT_BNEP_DEBUG ==========
net/bluetooth/bnep/netdev.c:#ifndef CONFIG_BT_BNEP_DEBUG
net/bluetooth/bnep/sock.c:#ifndef CONFIG_BT_BNEP_DEBUG
net/bluetooth/bnep/core.c:#ifndef CONFIG_BT_BNEP_DEBUG
========== BT_CMTP_DEBUG ==========
net/bluetooth/cmtp/capi.c:#ifndef CONFIG_BT_CMTP_DEBUG
net/bluetooth/cmtp/sock.c:#ifndef CONFIG_BT_CMTP_DEBUG
net/bluetooth/cmtp/core.c:#ifndef CONFIG_BT_CMTP_DEBUG
========== BT_HCI_CORE_DEBUG ==========
net/bluetooth/hci_core.c:#ifndef CONFIG_BT_HCI_CORE_DEBUG
net/bluetooth/hci_conn.c:#ifndef CONFIG_BT_HCI_CORE_DEBUG
net/bluetooth/hci_event.c:#ifndef CONFIG_BT_HCI_CORE_DEBUG
net/bluetooth/hci_sysfs.c:#ifndef CONFIG_BT_HCI_CORE_DEBUG
========== BT_HCI_SOCK_DEBUG ==========
net/bluetooth/hci_sock.c:#ifndef CONFIG_BT_HCI_SOCK_DEBUG
========== BT_HIDP_DEBUG ==========
net/bluetooth/hidp/sock.c:#ifndef CONFIG_BT_HIDP_DEBUG
net/bluetooth/hidp/core.c:#ifndef CONFIG_BT_HIDP_DEBUG
========== BT_L2CAP_DEBUG ==========
net/bluetooth/l2cap.c:#ifndef CONFIG_BT_L2CAP_DEBUG
========== BT_RFCOMM_DEBUG ==========
net/bluetooth/rfcomm/tty.c:#ifndef CONFIG_BT_RFCOMM_DEBUG
net/bluetooth/rfcomm/sock.c:#ifndef CONFIG_BT_RFCOMM_DEBUG
net/bluetooth/rfcomm/core.c:#ifndef CONFIG_BT_RFCOMM_DEBUG
========== BT_SCO_DEBUG ==========
net/bluetooth/sco.c:#ifndef CONFIG_BT_SCO_DEBUG
========== BT_SOCK_DEBUG ==========
net/bluetooth/af_bluetooth.c:#ifndef CONFIG_BT_SOCK_DEBUG

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
