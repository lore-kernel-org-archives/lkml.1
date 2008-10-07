Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYJGL0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYJGL0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYJGL0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:26:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42570 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbYJGL0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:26:06 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH, RFC] shmat: introduce flag SHM_MAP_HINT
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20081007112119.GG20740@one.firstfloor.org>
References: <20081007195837.5A6B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081007112119.GG20740@one.firstfloor.org>
Message-Id: <20081007202127.5A74.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue,  7 Oct 2008 20:26:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Honestly, I don't like that qemu specific feature insert into shmem core.
> 
> I wouldn't say it's a qemu specific interface.  While qemu would 
> be the first user I would expect more in the future. It's a pretty
> obvious extension. In fact it nearly should be default, if the
> risk of breaking old applications wasn't too high.

hm, ok, i understand your intension.
however, I think following code isn't self describing.

	addr = shmat(shmid, addr, SHM_MAP_HINT);

because HINT is too generic word.
I think we should find better word.

SHM_MAP_NO_FIXED ?


In addision, I still think current patch has too poor description and too 
few comments.



