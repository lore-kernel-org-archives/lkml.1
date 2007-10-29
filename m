Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbXJ2TjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbXJ2TjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXJ2Ti4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:38:56 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58097 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbXJ2Ti4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:38:56 -0400
To: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Message-Id: <eb2aa159d7f722c61d637feb287bc0f2f9519b1d.1193686445.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: kkeil@suse.de, akpm@linux-foundation.org
Subject: [PATCH 00/16] [ISDN] HiSax: modularize card setup
Date: Mon, 29 Oct 2007 15:38:55 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is my work-in-progress patch series killing the last user(s) of
pci_find_device(), by converting these ISDN drivers to the PCI hotplug
API.

This is NOT FOR MERGE, just for review -- and hopefully some testing.

There are clearly a few nits to clean up (some patches are obviously
fixes for bugs added in previous patches in this series) before it goes
any further.


