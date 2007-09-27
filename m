Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbXI0O3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbXI0O3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbXI0O3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:29:13 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34257 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbXI0O3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:29:12 -0400
Message-Id: <20070927143354.663489000@bull.net>
User-Agent: quilt/0.45-1
Date: Thu, 27 Sep 2007 16:33:54 +0200
From: Nadia.Derbey@bull.net
To: jarkao2@o2.pl
Cc: akpm@linux-foundation.org, adobriyan@sw.ru, linux-kernel@vger.kernel.org
Subject: [PATCH -mm1 0/2]  Fix unlocked call to idr_find()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This a series of 2 patches that should be applied on top of the other ipc
patches, in 2.6.23-rc6-mm1.

The first one is an answer to the following issue pointed out by Jarek:

> Jarek Poplawski wrote:
> 1. ipc_lock() and ipc_lock_check() are used without ipc_ids.mutex,
> but it's probably wrong: they call idr_find() with ipc_ids pointer
> which needs this mutex, just like in similar code in: ipc_findkey(),
> ipc_get_maxid() or sysvipc_find_ipc().

The second one is a trivial patch that removes an unneeded parameter for
2 routines.

They should be applied to 2.6.23-rc6-mm1, in the following order:

[PATCH 1/2]: ipc_fix_idr_find_locking.patch
[PATCH 2/2]: ipc_remove_unneeded_params.patch


Regards,
Nadia

--
