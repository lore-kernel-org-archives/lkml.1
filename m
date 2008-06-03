Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYFCXOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYFCXOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 19:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbYFCXN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 19:13:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:43741 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbYFCXN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 19:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=B0xgajwbz5csJz88IH41yQ0kSkPdVL72bkZbFoDK8Xer3k2jfA+XIwrGQXw/cqnSIlzB9ISPAwJMGvyRH92VupbfYjDUdxKxZ+ivexv82hSrioNRSgHeC7pYhygbIE2Vc7cpLsOfaAtiN9m/1fPIe5M20IMvSPUy0wybbUMV3Lo=
Date: Wed, 4 Jun 2008 07:13:39 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Ritesh Raj Sarraf <rrs@researchut.com>
Cc: Yan Li <elliot.li.tech@gmail.com>, Milan Broz <mbroz@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
       rjmaomao@gmail.com, Alasdair G Kergon <agk@redhat.com>,
       dm-crypt@saout.de
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Message-ID: <20080603231339.GA5995@yantp.cn.ibm.com>
References: <20080602030738.GA7761@yantp.cn.ibm.com> <48439890.6030904@redhat.com> <20080602123145.GA8258@yantp.cn.ibm.com> <2f83bcba0806031246m30f92892wc868d81a9c29d680@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f83bcba0806031246m30f92892wc868d81a9c29d680@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 01:16:30AM +0530, Ritesh Raj Sarraf wrote:
> Following is the bugzilla that was opened against this problem.
> http://bugzilla.kernel.org/show_bug.cgi?id=10378
> 
> Since I wasn't able to reproduce it on a server machine again, it was later
> closed.
> 
> If you think it is the same issue, please feel free to re-open it.

I think they are not the same. My problem lied in the slow crypto
computation under heavy I/O. I'm testing Milan Broz's patch, till now
it seems has solved my problem.

-- 
Li, Yan
