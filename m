Return-Path: <linux-kernel-owner+w=401wt.eu-S1763100AbZBYXIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763100AbZBYXIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760712AbZBYXI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:08:29 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:59228 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760508AbZBYXI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:08:27 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 0/5] drivers/isdn: fix sparse warnings
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Feb 2009 00:08:20 +0100
Message-ID: <20090225230737.5377.31370.stgit@localhost.localdomain>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes some sparse warnings in drivers/isdn.

---

Hannes Eder (5):
      drivers/isdn/hardware/eicon: fix sparse warnings: Should it be static?
      drivers/isdn/hardware/icon: fix sparse warning: cast truncates bits
      drivers/isdn/hisax: fix sparse warning: Should it be static?
      drivers/isdn/act2000: fix sparse warning: symbol shadows an earlier one
      drivers/isdn/capi: fix sparse warning: context imbalance


 drivers/isdn/act2000/act2000_isa.c    |    6 +--
 drivers/isdn/capi/kcapi_proc.c        |    2 +
 drivers/isdn/hardware/eicon/debug.c   |    2 -
 drivers/isdn/hardware/eicon/message.c |   70 ++++++++++++++++++++++-----------
 drivers/isdn/hisax/callc.c            |    1 
 drivers/isdn/hisax/config.c           |    6 ---
 drivers/isdn/hisax/hfcscard.c         |    2 -
 drivers/isdn/hisax/hisax.h            |    9 ++++
 drivers/isdn/hisax/isdnl1.c           |    4 +-
 drivers/isdn/hisax/sedlbauer.c        |    2 -
 drivers/isdn/hisax/teles0.c           |    2 -
 drivers/isdn/hisax/teles3.c           |    1 
 12 files changed, 63 insertions(+), 44 deletions(-)
