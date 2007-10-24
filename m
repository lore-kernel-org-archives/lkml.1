Return-Path: <linux-kernel-owner+w=401wt.eu-S1762322AbXJXQwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762322AbXJXQwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760706AbXJXQhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:37:36 -0400
Received: from ns2.suse.de ([195.135.220.15]:57014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761418AbXJXQhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:37:35 -0400
Message-Id: <20071024163733.366829630@strauss.suse.de>
User-Agent: quilt/0.46_cvs20071024-1
Date: Wed, 24 Oct 2007 18:37:33 +0200
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/2] Add flags to reserve_bootmem()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds a flags variable to reserve_bootmem() and uses the
BOOTMEM_EXCLUSIVE flag in crashkernel reservation code to detect collisions
between crashkernel area and already used memory.

