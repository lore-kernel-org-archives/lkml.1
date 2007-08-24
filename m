Return-Path: <linux-kernel-owner+w=401wt.eu-S932863AbXHXMw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbXHXMw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764894AbXHXMvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:51:44 -0400
Received: from hu-out-0506.google.com ([72.14.214.237]:58537 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763606AbXHXMvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:51:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JOnonU7WDM90YP/k0Gljcdu0T9WWdXacJfoeEStyQ7Yqm0UfIyfQOcoj0m02gTKEnPTviuVD8s847GABJrtjDSDl4mRPn2rZfBgzEOPj3yt19Xz5GxWevg2o5IRJ1v/0igZJ7vivXyHV+3vYHnGgECJpSd2vMqqsqRqj+6z6PKk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Fri, 24 Aug 2007 13:50:44 +0100
User-Agent: KMail/1.9.1
Cc: Satyam Sharma <satyam@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Christoph Lameter <clameter@sgi.com>, Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <20070809131423.GA9927@shell.boston.redhat.com> <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in> <18115.35524.56393.347841@cargo.ozlabs.ibm.com>
In-Reply-To: <18115.35524.56393.347841@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708241350.45061.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2007 00:22, Paul Mackerras wrote:
> Satyam Sharma writes:
> In the kernel we use atomic variables in precisely those situations
> where a variable is potentially accessed concurrently by multiple
> CPUs, and where each CPU needs to see updates done by other CPUs in a
> timely fashion.  That is what they are for.  Therefore the compiler
> must not cache values of atomic variables in registers; each
> atomic_read must result in a load and each atomic_set must result in a
> store.  Anything else will just lead to subtle bugs.

Amen.
--
vda
