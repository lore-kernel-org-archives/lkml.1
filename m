Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbYGCMBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbYGCMBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbYGCL7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 07:59:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46235 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbYGCL7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 07:59:53 -0400
Date: Thu, 03 Jul 2008 20:59:36 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: mchan@broadcom.com
Subject: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org
In-Reply-To: <20080703020236.adaa51fa.akpm@linux-foundation.org>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
Message-Id: <20080703205548.D6E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

my server output following error message on 2.6.26-rc8-mm1.
Is this a bug?

------------------------------------------------------------------
tg3.c:v3.93 (May 22, 2008)
GSI 72 (level, low) -> CPU 0 (0x0001) vector 51
tg3 0000:06:01.0: PCI INT A -> GSI 72 (level, low) -> IRQ 51
firmware: requesting tigon/tg3_tso.bin
tg3: Failed to load firmware "tigon/tg3_tso.bin"
tg3 0000:06:01.0: PCI INT A disabled
GSI 72 (level, low) -> CPU 0 (0x0001) vector 51 unregistered
tg3: probe of 0000:06:01.0 failed with error -2
GSI 73 (level, low) -> CPU 0 (0x0001) vector 51
tg3 0000:06:01.1: PCI INT B -> GSI 73 (level, low) -> IRQ 52
firmware: requesting tigon/tg3_tso.bin



