Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbZBKXXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbZBKXXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 18:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZBKXXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 18:23:39 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:48423 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501AbZBKXXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 18:23:38 -0500
Date: Thu, 12 Feb 2009 00:23:35 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Update jhash.h with the new version of Jenkins' hash
Message-ID: <20090211232335.GA16996@rere.qmqm.pl>
References: <alpine.DEB.2.00.0902111107480.15665@blackhole.kfki.hu> <20090211201908.GA25398@rere.qmqm.pl> <alpine.DEB.2.00.0902112334570.17583@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.0902112334570.17583@blackhole.kfki.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 11:50:38PM +0100, Jozsef Kadlecsik wrote:
> On Wed, 11 Feb 2009, Micha? Miros?aw wrote:
> > On Wed, Feb 11, 2009 at 11:19:20AM +0100, Jozsef Kadlecsik wrote:
> > >  /* The golden ration: an arbitrary value */
> > > -#define JHASH_GOLDEN_RATIO	0x9e3779b9
> > > +#define JHASH_GOLDEN_RATIO	0xdeadbeef
> > I have a stupid question: if this is arbitrary value, then why not
> > just get rid of it (IOW use zero as it's used in addition)?
> lookup3() is a quite generic hash function and it supports 0-byte strings 
> as input keys too. If the input key is a 0-byte string and the arbitrary 
> value is zero, then the hash value simply equal to the initval. In order 
> to avoid that case, the arbitrary value must be nonzero.

Double-hashing, of course! I really need more sleep. Sorry for the noise. :>

Best Regards,
Micha³ Miros³aw

