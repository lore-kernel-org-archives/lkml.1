Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYHYFeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYHYFeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 01:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYHYFeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 01:34:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:46183 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbYHYFeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 01:34:05 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, nix@esperi.org.uk, adobriyan@gmail.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/2] bio: blk_rq_map_* bounce support fixes
Date: Mon, 25 Aug 2008 14:22:51 +0900
Message-Id: <1219641773-25856-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <871w0eb9nx.fsf@hades.wkstn.nix>
References: <871w0eb9nx.fsf@hades.wkstn.nix>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes blk_rq_map_user_iov and blk_rq_map_kern bounce
support, which were introduced in 2.6.26. They can't handle READ
requests that partially completed.

This is against the for-linus branch in the block tree.

I think that we can clean up the code a bit (e.g. bio_copy_kern could
use __bio_copy_iov) but the patches need to go to the stable tree so I
kept the change to a minimum.


