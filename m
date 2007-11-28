Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbXK1VPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbXK1VPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbXK1VP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:15:28 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56229 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755018AbXK1VP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:15:27 -0500
Message-Id: <20071128210926.008783214@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 13:09:26 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 00/10] Per cpu code simplification V2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
- Rediff against 2.6.24-rc3-mm2

-- 
