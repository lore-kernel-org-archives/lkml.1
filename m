Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbYFZR5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbYFZR5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759863AbYFZR4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:56:55 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58081 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759861AbYFZR4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:56:54 -0400
Subject: saa7134 duplicate device in module, but different device_data?
From: Ben Collins <ben.collins@canonical.com>
To: v4l-dvb-maintainer@linuxtv.org
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 26 Jun 2008 13:24:53 -0400
Message-Id: <1214501094.7150.29.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the saa7134 module, there are these two entries in
MODULE_DEVICE_TABLE():


        },{
                .vendor       = PCI_VENDOR_ID_PHILIPS,
                .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
                .subvendor    = 0x185b,
                .subdevice    = 0xc100,
                .driver_data  = SAA7134_BOARD_VIDEOMATE_TV,
        },{
                .vendor       = PCI_VENDOR_ID_PHILIPS,
                .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
                .subvendor    = 0x185b,
                .subdevice    = 0xc100,
                .driver_data  = SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUS,
        },{

Both will exactly match, and I assume only the first one will ever be
used, hence the second is just a wasted dupe. At least, I would assume
if not for the differing driver_data. Anyway to clear up this ambiguity?

