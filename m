Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbZEZUYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbZEZUYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758014AbZEZUYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:24:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757966AbZEZUYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:24:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: wait_task_zombie: s/->parent/->real_parent/
In-Reply-To: Oleg Nesterov's message of  Monday, 25 May 2009 22:21:45 +0200 <20090525202145.GA25243@redhat.com>
References: <20090525202145.GA25243@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090526202336.E8B3AFC2BD@magilla.sf.frob.com>
Date: Tue, 26 May 2009 13:23:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Change wait_task_zombie() to use ->real_parent instead of ->parent.

Acked-by: Roland McGrath <roland@redhat.com>

> We could even use current afaics, but ->real_parent is more clean.

Indeed, though the caller might not be ->real_parent, it will always be
one that shares ->signal with ->real_parent.  But I agree that using
->real_parent is the clean way.  Incidentally, as readability cleanup it
would make a lot of sense to move that block into a subroutine.


Thanks,
Roland
