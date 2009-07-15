Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbZGOUTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbZGOUTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 16:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbZGOUTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 16:19:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142AbZGOUS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 16:18:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
X-Fcc: ~/Mail/linus
Cc: liqin.chen@sunplusct.com, Christoph Hellwig <hch@infradead.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH V2] score: add regset support
In-Reply-To: Arnd Bergmann's message of  Monday, 13 July 2009 16:24:28 +0200 <200907131624.28286.arnd@arndb.de>
References: <OF43365008.5559F266-ON482575F2.001F17EE-482575F2.00212259@sunplusct.com>
	<200907131624.28286.arnd@arndb.de>
X-Windows: the problem for your problem.
Message-Id: <20090715201817.9FF0840F7F@magilla.sf.frob.com>
Date: Wed, 15 Jul 2009 13:18:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMHO it is certainly a wise choice to have some struct (be it called
user_regs_struct or whatever) that describes the exact userland layout.
(I think it's also fine to just call that elf_gregset_t and have it be an
array, with REG_* defines/enum somewhere to document its indices.  It's
just a matter of taste for the arch folks.)

Given such a struct, the regset code can refer to it (with offsetof, e.g.)
and that will make it far easier to read, understand, and review.


Thanks,
Roland
