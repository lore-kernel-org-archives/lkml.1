Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbYACWDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbYACWDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 17:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYACWDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 17:03:07 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:53004 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYACWDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 17:03:05 -0500
Date: Thu, 3 Jan 2008 16:01:04 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: sam@ravnborg.org
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, wd@denx.de
Subject: [PATCH 0/3] Merge mkimage tool
Message-ID: <20080103160104.171f9aaa@zod.rchland.ibm.com>
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
platforms on those architectures.

This is currently based on the mkimage version found in U-Boot 1.3.1.
The tool is called mkubootimg in these patches, as mkimage is slightly
ambiguous outside of the U-Boot source tree.

Note: arch/powerpc the conversion in these patches as Paul's tree has
some changes that haven't hit Linus' tree yet.  I'll fixup arch/powerpc
as soon as these patches get merged.

josh
