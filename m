Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbXKFUmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbXKFUmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 15:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbXKFUmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 15:42:09 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:37160 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbXKFUmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 15:42:08 -0500
Message-Id: <20071106203724.620893371@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 15:37:24 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [patch 0/4] Move Instrumentation Support menu to arch/Kconfig
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  6 Nov 2007 20:41:52 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Following a discussion with Linus, here is the implementation of the
kernel/Kconfig.instrumentation removal. The result of the discussion has been
to decide to move the architecture dependent instrumentation menu entries to
arch/Kconfig and enable/disable each option on a per architecture basis with a
Kconfig boolean. I moved the architecture independent instrumentation items to
init/Kconfig.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
