Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbZLIUzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbZLIUzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757776AbZLIUzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:55:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757751AbZLIUzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:55:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: ptrace: don't abuse PT_PTRACED
In-Reply-To: Heiko Carstens's message of  Wednesday, 9 December 2009 21:51:12 +0100 <20091209205112.GB4351@osiris.boeblingen.de.ibm.com>
References: <20091209194651.GA24919@redhat.com>
	<20091209205112.GB4351@osiris.boeblingen.de.ibm.com>
Emacs: featuring the world's first municipal garbage collector!
Message-Id: <20091209205442.866B8CF7B@magilla.sf.frob.com>
Date: Wed,  9 Dec 2009 12:54:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks, applied. Even though I'm wondering why tracehook_consider_fatal_signal
> has a signal parameter and doesn't do anything with it.
> Is that something that will change with utrace?

It doesn't change with utrace of today.  But it gives enough information
for future tracing implementations to change that logic without rejiggering
all the arch code.


Thanks,
Roland
