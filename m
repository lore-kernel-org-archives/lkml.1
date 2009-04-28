Return-Path: <linux-kernel-owner+w=401wt.eu-S1761671AbZD1PGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761671AbZD1PGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbZD1PG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:06:29 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:33034
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753039AbZD1PG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:06:28 -0400
X-BigFish: VPS-8(zz1443R10d1Izz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KITGMH-01-UA3-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: akpm@linux-foundation.org, greg@kroah.com
CC: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 00/21] amd64_edac: EDAC module for AMD64
Date: Tue, 28 Apr 2009 17:05:52 +0200
Message-ID: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
X-OriginalArrivalTime: 28 Apr 2009 15:06:17.0537 (UTC) FILETIME=[E185AB10:01C9C812]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
hi Greg,

I think you've already heard about this driver, so here is a first
upstream submission request. It is quite sizable but partly the reason
for it is that it handles ECC detection and reporting for all AMD
K8, F10h and F11h families. It also implements DRAM error injection
functionality, failing DIMM module detection and some other fun stuff
found on F10h and later CPUs.

We've been doing testing/bugfixing/scrubbing here for some time, have
converted it to using kernel facilities and basically removed some slack
from it like glue code due to it being maintained out-of-tree. Please
take a look and let us know of any objections/comments you might have so
that we could tackle them on time.

Thanks in advance.

 drivers/edac/Kconfig      |   26 +
 drivers/edac/Makefile     |    1 +
 drivers/edac/amd64_edac.c | 5249 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 5276 insertions(+), 0 deletions(-)

