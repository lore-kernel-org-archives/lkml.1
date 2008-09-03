Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbYICSLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbYICSLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYICSLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:11:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39263 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbYICSLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:11:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Petr Tesarik <ptesarik@suse.cz>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] utrace core
In-Reply-To: Petr Tesarik's message of  Wednesday, 3 September 2008 14:58:27 +0200 <1220446707.6041.27.camel@elijah.suse.cz>
References: <20080826220102.89635154233@magilla.localdomain>
	<20080826220157.397C7154233@magilla.localdomain>
	<1220446707.6041.27.camel@elijah.suse.cz>
X-Zippy-Says: I want to dress you up as TALLULAH BANKHEAD and cover you with
    VASELINE and WHEAT THINS..
Message-Id: <20080903180854.61207154228@magilla.localdomain>
Date: Wed,  3 Sep 2008 11:08:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why does it depend on MODULES? 

Because otherwise it's not adding anything new anyone can use.

> Does this mean that when ptrace is switched to using the utrace engines,
> non-modular kernels will have to lack ptrace(2)?

No.  If that were done, then it would be:
	depends on MODULE || PTRACE
or suchlike.

> Is there anything in the code that actually breaks without
> CONFIG_MODULES?

No.


Thanks,
Roland
