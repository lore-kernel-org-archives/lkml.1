Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbZADA43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbZADA43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZADA4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:56:19 -0500
Received: from styx.suse.cz ([82.119.242.94]:50831 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750805AbZADA4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:56:19 -0500
Date: Sun, 4 Jan 2009 01:56:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>, Joerg Roedel <joerg.roedel@amd.com>
cc: linux-kernel@vger.kernel.org
Subject: iommu build failure
Message-ID: <alpine.LNX.1.10.0901040152430.5377@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

current Linus' tree (7d3b56ba37) doesn't build for me (config can be found 
on [1]):

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `alloc_iommu': drivers/pci/dmar.c:510: undefined reference to `iommu_calculate_agaw'
make: *** [.tmp_vmlinux1] Error 1

[1] http://labs.suse.cz/jikos/junk/.config-dmar-failure

-- 
Jiri Kosina
SUSE Labs
