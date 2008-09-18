Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbYIRXo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbYIRXo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbYIRXor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:44:47 -0400
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:46212 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbYIRXor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:44:47 -0400
Message-Id: <20080918233648.581696416@quilx.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Sep 2008 16:36:48 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
CC: linux-mm@vger.kernel.org
Cc: jeremy@goop.org
Cc: ebiederm@xmission.com
Cc: travis@sgi.com
Cc: herbert@gondor.apana.org.au
Cc: xemul@openvz.org
Subject: [patch 0/4] Cpu alloc V4: Replace percpu allocator in modules.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just do the bare mininum to establish a per cpu allocator. Later patchsets
will gradually build out the functionality.

The most critical issue that came up on the last round is how to configure
the size of the percpu area. Here we simply use a kernel parameter and use
the static size of the existing percpu allocator for modules as a default.

The effect of this patchset is to make the size of percpu data for modules
configurable. Its no longer fixed at 8000 bytes.

Changes:
- Gut patches to the bare essentials: Only replace modules.c percpu alloocator
- Make percpu reserve area configurable via a kernel parameter

-- 
