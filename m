Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbZLWBpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbZLWBpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 20:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZLWBpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 20:45:44 -0500
Received: from ozlabs.org ([203.10.76.45]:38908 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbZLWBpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 20:45:43 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0/3] Build fixes for test-devicetree
Message-Id: <1261532718.575048.365032094903.0.gpush@pororo>
To: Grant Likely <grant.likely@secretlab.ca>,
       devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Wed, 23 Dec 2009 09:45:18 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A small series of patches to fix minor build breakages when compiling
gcl's test-devicetree tree on ARM.

I've CC-ed lkml & linuxppc-dev for the fs/proc/ changes, but these
patches are only applicable to gcl's tree at present.

Cheers,


Jeremy

---
Jeremy Kerr (3):
      of: include linux/proc_fs.h
      of: make set_node_proc_entry private to proc_devtree.c
      proc_devtree: include linux/of.h

