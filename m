Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZGPJDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZGPJDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 05:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbZGPJDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 05:03:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59270 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbZGPJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 05:03:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Jul 2009 18:01:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       npiggin@suse.de,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       avi@redhat.com, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, aarcange@redhat.com
Subject: [PATCH 0/2] ZERO PAGE again v4.
Message-Id: <20090716180134.3393acde.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090709122428.8c2d4232.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090709122428.8c2d4232.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rebased onto  mm-of-the-moment snapshot 2009-07-15-20-57.
And modifeied to make vm_normal_page() eat FOLL_NOZERO, directly.

Any comments ?

Thanks,
-Kame

