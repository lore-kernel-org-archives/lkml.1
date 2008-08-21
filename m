Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbYHUVLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbYHUVLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYHUVLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:11:40 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:17098 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbYHUVLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:11:39 -0400
Date: Thu, 21 Aug 2008 15:11:37 -0600
From: Alex Chiang <achiang@hp.com>
To: jbarnes@virtuousgeek.org
Cc: kaneshige.kenji@jp.fujitsu.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] pciehp/shpchp prevent duplicate slot names
Message-ID: <20080821211137.GB24411@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
	kaneshige.kenji@jp.fujitsu.com, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

Here are patches:

	[PATCH 1/2] pciehp: Rename duplicate slot name N as N-1, N-2, N-M...
	[PATCH 2/2] shpchp: Rename duplicate slot name N as N-1, N-2, N-M...

Against Linus's 2.6.27-rc4.

As noted in the changelogs, these are temporary patches, meant as
placeholders until I complete the longer patch series that allows
the PCI core to manage the slot names on behalf of the drivers.

The longer patch series will keep the same behavior that these
temp patches implement, so that's goodness.

These patches have already been tested and acked by Kenji-san.

	http://article.gmane.org/gmane.linux.kernel/714583
	http://article.gmane.org/gmane.linux.kernel/714582

So I think you can add his sign-offs too.

Thanks,

/ac

