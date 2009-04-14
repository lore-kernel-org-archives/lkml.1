Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbZDNQtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbZDNQtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbZDNQti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:49:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51387 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487AbZDNQth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:49:37 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH v3 3/6] nfs, direct-io: fix fork vs direct-io race on nfs
References: <20090414151204.C647.A69D9226@jp.fujitsu.com>
	<20090414151806.C650.A69D9226@jp.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 14 Apr 2009 12:48:01 -0400
In-Reply-To: <20090414151806.C650.A69D9226@jp.fujitsu.com> (KOSAKI Motohiro's
	message of "Tue, 14 Apr 2009 15:19:24 +0900 (JST)")
Message-ID: <x4963h7yyf2.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:

> Subject: [PATCH] nfs, direct-io: fix fork vs direct-io race on nfs
>
> After fs/diorect-io.c fix, following testcase still fail on nfs running.
> it's because nfs has own specific diorct-io implementation.

Same issue as 2/6.

Cheers,
Jeff
