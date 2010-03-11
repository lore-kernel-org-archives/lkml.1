Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0CKRb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:31:57 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:63562 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab0CKRb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:31:56 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 0/3] Various OF cleanups
To: devicetree-discuss@lists.ozlabs.org, benh@kernel.crashing.org,
       davem@davemloft.net, jeremy.kerr@canonical.com, monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org
Date: Thu, 11 Mar 2010 10:31:52 -0700
Message-ID: <20100311173024.4423.53178.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some simple fixes to make the OF header files safe to include
when CONFIG_OF is not set, and add some debug context messages.

Cheers,
g.

---

Grant Likely (3):
      of: protect contents of of_platform.h and of_device.h
      of/flattree: Make unflatten_device_tree() safe to call from any arch
      of/flattree: make of_fdt.h safe to unconditionally include.


 drivers/of/fdt.c            |   15 +++++++++++++++
 include/linux/of_device.h   |    2 ++
 include/linux/of_fdt.h      |    4 ++++
 include/linux/of_platform.h |    2 ++
 4 files changed, 23 insertions(+), 0 deletions(-)

-- 
Signature
