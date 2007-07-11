Return-Path: <linux-kernel-owner+w=401wt.eu-S1763069AbXGKNfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763069AbXGKNfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763016AbXGKNfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:35:21 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:36111 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762180AbXGKNfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:35:18 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, muli@il.ibm.com, jdmason@kudzu.us
Subject: Calgary: more updates for 2.6.23
Date: Wed, 11 Jul 2007 16:35:10 +0300
Message-Id: <11841609143732-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.5.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Here are a few more Calgary updates that are appropriate for
2.6.23. The only notable one is the second one, which tightens up the
bitmap locking to only lock where absolutely necessary, giving us a
nice 10-15% improvement in CPU utilization running netperf on a large
SMP machine. Please apply.

Thanks,
Muli

