Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847Ab0AEPYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0AEPYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060Ab0AEPYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:24:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab0AEPYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:24:03 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LSU.2.00.1001051232530.1055@sister.anvils>
References: <alpine.LSU.2.00.1001051232530.1055@sister.anvils> <alpine.LSU.2.00.0912302009040.30390@sister.anvils> <20100104123858.GA5045@us.ibm.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] nommu: reject MAP_HUGETLB
Date: Tue, 05 Jan 2010 15:23:33 +0000
Message-ID: <17220.1262705013@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> We've agreed to restore the rejection of MAP_HUGETLB to nommu.
> Mimic what happens with mmu when hugetlb is not configured in:
> say -ENOSYS, but -EINVAL if MAP_ANONYMOUS was not given too.

On the other hand, why not just ignore the MAP_HUGETLB flag on NOMMU?

David
