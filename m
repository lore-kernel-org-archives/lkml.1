Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbXL1AQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbXL1AQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 19:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbXL1AQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 19:16:19 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58080 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755151AbXL1AQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 19:16:18 -0500
Message-Id: <20071228001617.597161000@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Dec 2007 16:16:17 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 00/10] percpu: Per cpu code simplification V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[resending as my first attempt sent only a partial list.]

This patchset simplifies the code that arches need to maintain to support
per cpu functionality. Most of the code is moved into arch independent
code. Only a minimal set of definitions is kept for each arch.

The patch also unifies the x86 arch so that there is only a single
asm-x86/percpu.h

V1->V2:
- Add support for specifying attributes for per cpu declarations (preserves
  IA64 model(small) attribute).
  - Drop first patch that removes the model(small) attribute for IA64
  - Missing #endif in powerpc generic config /  Wrong Kconfig
  - Follow Randy's suggestions on how to do the Kconfig settings


Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>

-- 
