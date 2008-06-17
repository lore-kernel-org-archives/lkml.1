Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbYFQPei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbYFQPei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 11:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYFQPe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 11:34:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51065 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbYFQPe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 11:34:27 -0400
Date: Wed, 18 Jun 2008 00:34:16 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [Bad page] trying to free locked page? (Re: [PATCH][RFC] fix kernel BUG at mm/migrate.c:719! in 2.6.26-rc5-mm3)
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
In-Reply-To: <20080617164709.de4db070.nishimura@mxp.nes.nec.co.jp>
References: <20080617163501.7cf411ee.nishimura@mxp.nes.nec.co.jp> <20080617164709.de4db070.nishimura@mxp.nes.nec.co.jp>
Message-Id: <20080618003334.DE2A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I got this bug while migrating pages only a few times
> > via memory_migrate of cpuset.
> > 
> > Unfortunately, even if this patch is applied,
> > I got bad_page problem after hundreds times of page migration
> > (I'll report it in another mail).
> > But I believe something like this patch is needed anyway.
> > 
> 
> I got bad_page after hundreds times of page migration.
> It seems that a locked page is being freed.

I can't reproduce this bad page.
I'll try again tomorrow ;)



