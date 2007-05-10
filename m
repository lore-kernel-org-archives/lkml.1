Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbXEJT7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbXEJT7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXEJT66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:58:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbXEJT65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:58:57 -0400
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6
From: Dan Williams <dcbw@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Marcelo Tosatti <marcelo@kvack.org>, David Miller <davem@davemloft.net>,
       penberg@cs.helsinki.fi, linville@tuxdriver.com, hch@infradead.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-Reply-To: <46424018.2010306@garzik.org>
References: <20070507141143.GB5125@tuxdriver.com>
	 <463F443A.5000306@garzik.org>
	 <84144f020705080247v74ebcd26y27c2f1e61529b215@mail.gmail.com>
	 <20070508.132737.104034594.davem@davemloft.net>
	 <4640E3BF.8080401@garzik.org>
	 <1178659763.14888.2.camel@localhost.localdomain>
	 <4640FC76.4090908@garzik.org> <20070508234118.GA3472@dmt>
	 <1178674020.16181.4.camel@localhost.localdomain>
	 <20070509142516.a31467c5.randy.dunlap@oracle.com>
	 <1178746884.9590.18.camel@localhost.localdomain>
	 <46424018.2010306@garzik.org>
Content-Type: text/plain
Date: Thu, 10 May 2007 14:35:44 -0400
Message-Id: <1178822144.4028.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 17:41 -0400, Jeff Garzik wrote:
> Dan Williams wrote:
> > I can fix those up; but setting KBUILD_VERBOSE=1 and recompiling doesn't
> > show any of them in current libertas-2.6; -Wall is definitely defined.
> > Is there another way to enable something give yet more verbose debug
> > output?
> 
> 
> The copious libertas warnings are present in vanilla upstream 
> linux-2.6.git.
> 
> Just do "make allmodconfig && make -sj4".
> 
> 	Jeff
> 
> 
> P.S. Make sure libertas is free of sparse warnings, as all drivers 
> should be.  Read Documentation/sparse.txt.

Sparse stuff fixed.  Still getting working on 64-bit compiles.

Dan

> 	Jeff
> 
> 
> 

