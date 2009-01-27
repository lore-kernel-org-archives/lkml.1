Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbZA0F7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbZA0F7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZA0F65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:58:57 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57118 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbZA0F65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:58:57 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Kyle McMartin <kyle@infradead.org>
Subject: Re: [PATCH] make checkpatch warn about access to current->comm
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Bartelmus <lirc@bartelmus.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20090127055205.GC5034@bombadil.infradead.org>
References: <20090128144316.D467.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090127055205.GC5034@bombadil.infradead.org>
Message-Id: <20090128145534.D46A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 27 Jan 2009 14:58:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jan 27, 2009 at 02:50:18PM +0900, KOSAKI Motohiro wrote:
> > I think "char tcomm[sizeof(current->comm)];" is valid code.
> > if checkpatch.pl don't warn "sizeof(current->comm)", I'm glad.
> 
> Awfully interesting way of writing TASK_COMM_LEN :)

I don't think so awfully.
I think "sizeof(array_val)" is typical code in kernel.

I agree that we can rewrite s/tcomm[sizeof(current->comm)]/char tcomm[TASK_COMM_LEN]/.
but it's annoyed.



