Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZIPN0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZIPN0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZIPNY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:24:58 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57890 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbZIPNYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:47 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no
Subject: [PATCH 0/16] Post merge per-bdi writeback patches v4
Date: Wed, 16 Sep 2009 15:24:38 +0200
Message-Id: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After Jan's feedback and collecting the good fixes from Nick,
here's another updated set of fixes.

Jan, I kept the wb_check_old_data_flush() behaviour. I agree we
need to look into making sure it's identical to the previous one,
but at least this one doesn't change behaviour from current -git.
And I'd really like to offload this patchset now since it has
some crucial fixes, then I'll continue with the process afterwards.

-- 
Jens Axboe

