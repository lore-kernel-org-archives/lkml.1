Return-Path: <linux-kernel-owner+w=401wt.eu-S936339AbXLTQWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936339AbXLTQWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764249AbXLTQWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:22:21 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53132 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763962AbXLTQWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:22:20 -0500
Date: Thu, 20 Dec 2007 10:16:43 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: paulus@samba.org
Subject: [RFC] Merge mkimage tool
Message-ID: <20071220101643.48b427ef@zod.rchland.ibm.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches merge the mkimage tool into the kernel.  This
utility is used by several arches to create a uImage file suitable for
booting with U-Boot.

As it stands today, a mkuboot.sh script is called, which searches for
the mkimage utility installed on the host system.  This is slightly
suboptimal as it prevents things like automated rebuilds of certain
platforms on those architectures, particularly powerpc.

This is currently based on the mkimage version found in U-Boot 1.3.1.

Comments, flames, suggestions, insults, monetary donations welcome.
Please CC me on replies, as I'm not subscribed to lkml with this
address.

josh
