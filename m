Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbYKEX11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbYKEX11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 18:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYKEX1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 18:27:05 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:44612 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbYKEX1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 18:27:04 -0500
Message-Id: <20081105231634.133252042@quilx.com>
User-Agent: quilt/0.46-1
Date: Wed, 05 Nov 2008 17:16:34 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: travis@sgi.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Subject: [patch 0/7] cpu alloc stage 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second stage of the cpu_alloc patchset can be pulled from

git.kernel.org/pub/scm/linux/kernel/git/christoph/work.git cpu_alloc_stage2

Stage 2 includes the conversion of the page allocator
and slub allocator to the use of the cpu allocator.

It also includes the core of the atomic vs. interrupt cpu ops and uses those
for the vm statistics.

-- 
