Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbYAXWc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbYAXWc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYAXWcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:32:17 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:63969 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbYAXWcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:32:16 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: [PATCH 0/9] bfs: assorted cleanups
Date: Fri, 25 Jan 2008 01:31:59 +0300
Message-Id: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Adrian,

Last time when I had sent some BFS bugfixes to the maintainer of
this filesystem driver, he did not respond, and Andrew Morton
had to take care of those.

For this reason, and because the patches in this little patch bomb
are trivial, I am sending this to you in the hope that these can
be pushed upstream when the next merge window opens.

In case you'll be wondering why I need BFS: I teach system programming
and operating systems at the premises of the Moscow State University.
The BFS code is used as an example of a simple filesystem driver
implementation in Linux. This hopefully explains why I want to have
clean code in here :)

Some checkpatch.pl stats follow.

Before:

----------------------------------------
|         | errors | warnings | checks |
----------------------------------------
| bfs.h   |   2    |    0     |   0    |
----------------------------------------
| dir.c   |   7    |    1     |   4    |
----------------------------------------
| file.c  |   6    |    0     |   2    |
----------------------------------------
| inode.c |   11   |    0     |   3    |
----------------------------------------

After:

----------------------------------------
|         | errors | warnings | checks |
----------------------------------------
| bfs.h   |   0    |    0     |   0    |
----------------------------------------
| dir.c   |   0    |    0     |   0    |
----------------------------------------
| file.c  |   0    |    0     |   0    |
----------------------------------------
| inode.c |   0    |    0     |   0    |
----------------------------------------

Please consider.

Thanks,

Dmitri Vorobiev
