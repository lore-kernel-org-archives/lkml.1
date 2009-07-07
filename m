Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbZGGQ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbZGGQ20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZGGQ2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:28:18 -0400
Received: from smtp.nokia.com ([192.100.122.233]:61227 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbZGGQ2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:28:17 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2009 21:18:39 +0300
Message-Id: <20090707181839.17058.717.sendpatchset@localhost.localdomain>
Subject: [PATCH v2 0/2] periodic sync_supers timer optimization
X-OriginalArrivalTime: 07 Jul 2009 16:28:08.0128 (UTC) FILETIME=[E960E400:01C9FF1F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Fixing may e-mail address and re-sending, sorry]

Hi Jens,

here is an optimization of the periodic sync_supers tread which
wakes up every 5 seconds no matter what. The optimization is
done against the 'writeback-v12' of your 'linux-2.6-block' tree.

Note, I have VFS/file-systems changes in a decomposed form, but
I folded that all into one patch to avoid flooding the mailing
list with many tiny patches.

What do you think about this?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
