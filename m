Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZJCOdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZJCOdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 10:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbZJCOdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 10:33:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:38924 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751943AbZJCOdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 10:33:18 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19qPwcEBIFqpz8u2bUw+KXGv7TLSOWBifd/WY54Rf
	o5xmHN1ZxYh9wT
Subject: Re: Do not overload dispatch queue (Was: Re: IO scheduler based IO
 controller V10)
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
In-Reply-To: <20091003142840.GE31616@kernel.dk>
References: <20091002173732.GK31616@kernel.dk>
	 <1254507215.8667.7.camel@marge.simson.net>
	 <20091002181903.GN31616@kernel.dk>
	 <1254548931.8299.18.camel@marge.simson.net>
	 <1254549378.8299.21.camel@marge.simson.net>
	 <20091003112915.GA12925@redhat.com> <20091003124049.GB12925@redhat.com>
	 <20091003132115.GB31616@kernel.dk> <20091003135623.GD12925@redhat.com>
	 <1254578553.7499.5.camel@marge.simson.net>
	 <20091003142840.GE31616@kernel.dk>
Content-Type: text/plain
Date: Sat, 03 Oct 2009 16:33:16 +0200
Message-Id: <1254580396.8293.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-03 at 16:28 +0200, Jens Axboe wrote:
> On Sat, Oct 03 2009, Mike Galbraith wrote:
> > On Sat, 2009-10-03 at 09:56 -0400, Vivek Goyal wrote:
> > 
> > > I have kept the overload delay period as "cfq_slice_sync" same as Mike had
> > > done. We shall have to experiment what is a good waiting perioed. Is 100ms
> > > too long if we are waiting for a request from same process which recently
> > > finished IO and we did not enable idle on it.
> > > 
> > > I guess we can tweak the delay period as we move along.
> > 
> > I kept the delay period very short to minimize possible damage. Without
> > the idle thing, it wasn't enough, but with, worked a treat, as does your
> > patch.
> 
> Can you test the current line up of patches in for-linus? It has the
> ramp up I talked about included as well.

Sure.  I'll go find it.

	-Mike

