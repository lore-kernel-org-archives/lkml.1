Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbXBZTvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbXBZTvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 14:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbXBZTvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 14:51:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbXBZTvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 14:51:11 -0500
Message-ID: <45E33A2A.2050506@redhat.com>
Date: Mon, 26 Feb 2007 14:51:06 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: SCSI devices with 256-byte sectors don't work?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently there really are such devices:

Sep 28 20:05:42 localhost kernel: scsi4 : SCSI emulation for USB Mass Storage devices
Sep 28 20:05:42 localhost kernel:   Vendor: Sandisk   Model: ImageMate SDDR09  Rev: 0100
Sep 28 20:05:42 localhost kernel:   Type:   Direct-Access            ANSI SCSI revision: 02
Sep 28 20:05:51 localhost kernel: sddr09: Found Flash card, ID = 98 EA 00 00: Manuf. Toshiba, 2 MB
Sep 28 20:05:51 localhost kernel: SCSI device sdd: 8160 256-byte hdwr sectors (2 MB)
Sep 28 20:05:51 localhost kernel: sdd: test WP failed, assume Write Enabled
Sep 28 20:05:51 localhost kernel: sdd: assuming drive cache: write through
Sep 28 20:05:51 localhost kernel:  sdd:SCSI error : <4 0 0 0> return code = 0x10070000
Sep 28 20:05:51 localhost kernel: end_request: I/O error, dev sdd, sector 0
Sep 28 20:05:51 localhost kernel: Buffer I/O error on device sdd, logical block 0

Last three lines just repeat over and over.
