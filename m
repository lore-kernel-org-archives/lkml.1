Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbYLJSzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbYLJSzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbYLJSzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:55:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:58068 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbYLJSzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:55:31 -0500
Message-ID: <494010AB.5030304@vlnb.net>
Date: Wed, 10 Dec 2008 21:55:39 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Vu Pham <huongvp@yahoo.com>, Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH][RFC 17/23]: InfiniBand SRP target driver
References: <494009D7.4020602@vlnb.net>
In-Reply-To: <494009D7.4020602@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18FBM/dVdkEgJAPAA0np694E6gl7quBe0QJ4tB
 6YvfZzv3vdnLbwzLlogGlV4Sx/F8S07bIbJ8Yj3OramMpuCpJO
 vEqU3q3RvGsRlLtuvKcAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains target mode driver for InfiniBand SRP.

This driver work directly on top of InfiniBand stack and SCST.

Signed-off-by: Vu Pham <vu@mellanox.com>
Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scst/srpt/Kconfig     |   12
  drivers/scst/srpt/Makefile    |    4
  drivers/scst/srpt/ib_dm_mad.h |  106 ++
  drivers/scst/srpt/ib_srpt.c   | 2307 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/scst/srpt/ib_srpt.h   |  201 +++++
  5 files changed, 2630 insertions(+)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/srpt.diff



