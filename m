Return-Path: <linux-kernel-owner+w=401wt.eu-S1765621AbYEFTeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765621AbYEFTeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760526AbYEFTeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:34:05 -0400
Received: from relay2.sgi.com ([192.48.171.30]:35642 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757028AbYEFTeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:34:03 -0400
Message-Id: <20080506193352.225379637@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 May 2008 12:33:52 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>
Subject: [patch 0/4] [PATCH] x86: Merge e820_32/64 V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V1->V2:
- Harmonize calling conventions betwen 32 and 64 bit. Use u64 if 32 bit uses
  unsigned long long or u64.

The following patchset merges the 32 and 64 bit of e820 header files into one.

First just move the stuff into a single file and then gradually extract common
code.

Patch against Linus' git tree of today.

-- 
