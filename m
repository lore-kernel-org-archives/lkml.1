Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbYCTMa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbYCTMa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 08:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYCTMaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 08:30:22 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:55606 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753363AbYCTMaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 08:30:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQFAKb14UdMQWoK/2dsb2JhbACBWqkC
Date: Thu, 20 Mar 2008 08:30:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jon Masters <jcm@jonmasters.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jon Masters <jcm@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] Markers Support for Proprierary Modules
Message-ID: <20080320123014.GA15987@Krystal>
References: <20080320002737.918213455@polymtl.ca> <20080320002835.384758480@polymtl.ca> <200803201635.30795.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200803201635.30795.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:27:40 up 20 days,  8:38,  4 users,  load average: 0.65, 0.65,
	0.71
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Thursday 20 March 2008 11:27:41 Mathieu Desnoyers wrote:
> > There seems to be good arguments for markers to support proprierary
> > modules. So I am throwing this one-liner in and let's see how people react.
> > It only makes sure that a module that has been "forced" to be loaded won't
> > have its markers used. It is important to leave this check to make sure the
> > kernel does not crash by expecting the markers part of the struct module by
> > mistake in the case there is an incorrect checksum.
> 
> OK, I've applied this to my tree.  That means it will be in 2.6.26 unless you 
> want me to push it earlier.
> 
> Thanks,
> Rusty.

I think it's ok to wait for 2.6.26, since we are already very far in the
2.6.25 release process and it's more a "feature" than a "bugfix".

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
