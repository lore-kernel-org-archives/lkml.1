Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbYH2NpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbYH2NpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 09:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbYH2Noo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 09:44:44 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:33835 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756572AbYH2Non (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 09:44:43 -0400
Message-Id: <20080829134158.108976037@vixen.sonytel.be>
User-Agent: quilt/0.46-1
Date: Fri, 29 Aug 2008 15:41:58 +0200
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: linux-crypto@vger.kernel.org, squashfs-devel@lists.sourceforge.net
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3] [RFC] zlib crypto module
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add a (de)compression module for the "zlib" format using the
crypto API:
  [1] crypto: Add a zlib crypto module
  [2] tcrypt: Add a self test for the zlib crypto module
  [3] squashfs: Switch from zlib/inflate to "zlib" crypto module

The last patch is a proof-of-concept to make SquashFS 3.4 use this new zlib
crypto module. This makes it easier to e.g. change the decompression algorithm
in SquashFS or to make use of a hardware-accelerated zlib crypto module.

It can be extended to other compressed file systems, like e.g. AxFS and CRAMFS.

All comments are welcome. Thanks!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010

