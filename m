Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbYAPWGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbYAPWGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYAPWGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:06:11 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51581 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYAPWGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:06:08 -0500
Date: Wed, 16 Jan 2008 14:11:52 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 0/2] x86: MMCONF init sequence
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jeff Garzik <jeff@garzik.org>,
       Greg KH <greg@kroah.com>, Robert Hancock <hancockr@shaw.ca>,
       Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200801161411.52885.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check 

1. add pci_mmcfg_arch_free for x86_64
2. change back init sequence so we can use mmconf even acpi=off

all against to x86.git

YH
