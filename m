Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377Ab0AYXud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab0AYXud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 18:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828Ab0AYXuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 18:50:32 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:13795 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab0AYXub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 18:50:31 -0500
X-IMAP-Sender: achiang
Date: Mon, 25 Jan 2010 16:50:13 -0700
X-OfflineIMAP-17222630-6c646c-494e424f582e4f7574626f78: 1264463430-0738783592365-v6.2.0
From: Alex Chiang <achiang@hp.com>
To: linux-rdma@vger.kernel.org
Cc: justin.chen@hp.com, linux-kernel@vger.kernel.org
Subject: infiniband limit of 32 cards per system?
Message-ID: <20100125235013.GD2828@grease.ALLEYCAT>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm pretty unfamiliar with Infiniband, so apologies for the
stupid question.

Is there a limit on how many IB devices a system might support?

My colleague points out the following enum in uverbs_main.c:

	enum {
		IB_UVERBS_MAJOR       = 231,
		IB_UVERBS_BASE_MINOR  = 192,
		IB_UVERBS_MAX_DEVICES = 32
	};

Experimentally, we've determined that on a system where we
plugged in 40 IB cards, OFED only reports 32 cards are present.

If that enum is indeed the limiting factor, would someone mind
explaining (or pointing me at TFM ;) why it's limited to 32
devices?

Thanks,
/ac

