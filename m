Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbZBLNFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbZBLNFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 08:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbZBLNFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 08:05:30 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:46998 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643AbZBLNF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 08:05:29 -0500
Date: Thu, 12 Feb 2009 14:05:20 +0100
To: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: iwl breaking on suspend/resume, regression from 2.6.29-rc3
Message-ID: <20090212130520.GA19991@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

since I have switched to 2.6.29-rc4 (from rc3) suspending and resuming
takes MUCH longer due to iwlagn doing something strange:
[ 6921.233094] iwlagn: Could not load the INST uCode section
[ 6921.233097] iwlagn: Unable to set up bootstrap uCode: -110
[ 6926.233096] iwlagn: Could not load the INST uCode section
[ 6926.233098] iwlagn: Unable to set up bootstrap uCode: -110
[ 6931.233136] iwlagn: Could not load the INST uCode section
[ 6931.233138] iwlagn: Unable to set up bootstrap uCode: -110
[ 6936.233096] iwlagn: Could not load the INST uCode section
[ 6936.233098] iwlagn: Unable to set up bootstrap uCode: -110
[ 6941.233094] iwlagn: Could not load the INST uCode section
[ 6941.233096] iwlagn: Unable to set up bootstrap uCode: -110
[ 6941.241144] iwlagn: Unable to initialize device after 5 attempts.

Here is what I have in the laptop:
[   13.028298] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
[   13.028366] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[   13.028496] iwlagn 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   13.028580] iwlagn 0000:06:00.0: setting latency timer to 64
[   13.028625] iwlagn: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
[   13.050694] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[   13.051006] iwlagn 0000:06:00.0: PCI INT A disabled


Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
NOTTAGE (n.)
Nottage is the collective name for things which you find a use for
immediately after you've thrown them away. For instance, your
greenhouse has been cluttered up for years with a huge piece of
cardboard and great fronds of gardening string. You at last decide to
clear all this stuff out, and you burn it. Within twenty-four hours
you will urgently need to wrap a large parcel, and suddenly remember
that luckily in your greenhouse there is some cardb...
			--- Douglas Adams, The Meaning of Liff
