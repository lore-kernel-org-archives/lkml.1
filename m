Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbYGCMMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbYGCMMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbYGCMMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:12:05 -0400
Received: from fgwmail8.fujitsu.co.jp ([192.51.44.38]:56177 "EHLO
	fgwmail8.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYGCMMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:12:03 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 08:12:03 EDT
Date: Thu, 03 Jul 2008 18:41:47 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [-mm] BUG: sleeping function called from invalid context at include/linux/pagemap.h:290
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, npiggin@suse.de,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik Van Riel <riel@redhat.com>
In-Reply-To: <486C74B1.3000007@cn.fujitsu.com>
References: <486C74B1.3000007@cn.fujitsu.com>
Message-Id: <20080703183913.D6DF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Seems the problematic patch is :
> mmap-handle-mlocked-pages-during-map-remap-unmap.patch
> 
> I'm using mmotm uploaded yesterday by Andrew, so I guess this bug
> has not been fixed ?
> 
> BUG: sleeping function called from invalid context at include/linux/pagemap.h:290
> in_atomic():1, irqs_disabled():0
> no locks held by gpg-agent/2134.

Li-san, I tested 2.6.26-rc8-mm1 on x86_64.
but I can't reproduce it.

Could you explain detail of reproduce way?



