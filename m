Return-Path: <linux-kernel-owner+w=401wt.eu-S1758827AbXEIVmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbXEIVmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbXEIVmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:42:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48126 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbXEIVmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:42:06 -0400
Message-ID: <46424018.2010306@garzik.org>
Date: Wed, 09 May 2007 17:41:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Marcelo Tosatti <marcelo@kvack.org>, David Miller <davem@davemloft.net>,
       penberg@cs.helsinki.fi, linville@tuxdriver.com, hch@infradead.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6
References: <20070507141143.GB5125@tuxdriver.com>	 <463F443A.5000306@garzik.org>	 <84144f020705080247v74ebcd26y27c2f1e61529b215@mail.gmail.com>	 <20070508.132737.104034594.davem@davemloft.net>	 <4640E3BF.8080401@garzik.org>	 <1178659763.14888.2.camel@localhost.localdomain>	 <4640FC76.4090908@garzik.org> <20070508234118.GA3472@dmt>	 <1178674020.16181.4.camel@localhost.localdomain>	 <20070509142516.a31467c5.randy.dunlap@oracle.com> <1178746884.9590.18.camel@localhost.localdomain>
In-Reply-To: <1178746884.9590.18.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> I can fix those up; but setting KBUILD_VERBOSE=1 and recompiling doesn't
> show any of them in current libertas-2.6; -Wall is definitely defined.
> Is there another way to enable something give yet more verbose debug
> output?


The copious libertas warnings are present in vanilla upstream 
linux-2.6.git.

Just do "make allmodconfig && make -sj4".

	Jeff


P.S. Make sure libertas is free of sparse warnings, as all drivers 
should be.  Read Documentation/sparse.txt.

	Jeff



