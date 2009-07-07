Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbZGGQP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbZGGQP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbZGGQPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:15:36 -0400
Received: from smtp.nokia.com ([192.100.122.230]:42503 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737AbZGGQPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:15:33 -0400
From: Artem Bityutskiy <dedekind1@nokia.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, Artem Bityutskiy <dedekind1@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2009 21:05:41 +0300
Message-Id: <20090707180541.17048.49901.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/2] periodic sync_supers timer optimization
X-OriginalArrivalTime: 07 Jul 2009 16:15:06.0990 (UTC) FILETIME=[17C8B0E0:01C9FF1E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
