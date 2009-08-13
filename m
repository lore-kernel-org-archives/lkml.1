Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZHMUIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZHMUIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbZHMUIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:08:41 -0400
Received: from vena.lwn.net ([206.168.112.25]:46249 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145AbZHMUIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:08:40 -0400
Date: Thu, 13 Aug 2009 14:05:54 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mark Gross <mgross@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH, RESEND 0/2] pm_qos: remove BKL and de-race
Message-ID: <20090813140554.014ce1e0@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a repost of my two-patch set getting rid of the BKL and some
racy code in pm_qos_params.c.  There's been no changes since the last
time around other than the addition of a couple of tags.  Patches
follow, or they can be pulled from:

	git://git.lwn.net/linux-2.6.git bkl-removal

Ingo, you didn't say whether these could find a home in your
violent-death-to-the-bkl tree until the merge window opens.  So they're
still looking for a place to rest; I guess I could ask Stephen to take
the bkl-removal tree back into linux-next, but that seems like
overkill.

Thanks,

jon
