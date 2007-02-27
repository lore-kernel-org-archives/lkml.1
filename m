Return-Path: <linux-kernel-owner+w=401wt.eu-S965188AbXB0AL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188AbXB0AL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965273AbXB0ALz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:11:55 -0500
Received: from mga05.intel.com ([192.55.52.89]:15806 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965188AbXB0ALy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:11:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,221,1170662400"; 
   d="scan'208"; a="204341127:sNHT53598454"
Message-Id: <20070227001338.344233745@sodium.jf.intel.com>
User-Agent: quilt/0.45-1
Date: Mon, 26 Feb 2007 16:13:38 -0800
From: inaky@linux.intel.com
To: Arjan van de Ven <arjan@infradead.org>, mingo@redhat.com, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/2] semaphores: add down_interruptible_timeout() and asm-generic/semaphore.h
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce down_interruptible_timeout() using timers to make the waiter
stop waiting by simulating a signal (see first patch for more
details). As well introduce asm-generic/semaphore.h and make other
architectures use it too.

--

Inaky
