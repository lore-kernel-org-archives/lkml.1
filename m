Return-Path: <linux-kernel-owner+w=401wt.eu-S1760452AbYGCI2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760452AbYGCI2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 04:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYGCIRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 04:17:02 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35016 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936993AbYGCHPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 03:15:38 -0400
Date: Thu, 03 Jul 2008 16:13:29 +0900
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
Message-Id: <20080703161028.D6CC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
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

sorry for that.
I started investigate this problem.




