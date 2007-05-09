Return-Path: <linux-kernel-owner+w=401wt.eu-S1032637AbXEIC4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032637AbXEIC4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032422AbXEIC40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:56:26 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50740 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032390AbXEIC4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:56:24 -0400
Message-ID: <46413851.6070505@zytor.com>
Date: Tue, 08 May 2007 19:56:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@osdl.org>
CC: "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Please revert 464bdd33e9baad9806c7adbd8dfc37081a55f27e
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Checkin 464bdd33e9baad9806c7adbd8dfc37081a55f27e "fbdev: ignore VESA
modes if framebuffer is disabled" is just plain wrong on any system
which has support for extended text modes in its VESA BIOS.

Antonio is incorrectly assuming this branchout is used only to set VESA
graphics modes, but it's to set any VESA mode, be it text or graphics.

	-pa

