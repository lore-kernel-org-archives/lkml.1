Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbZJMLwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbZJMLwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759567AbZJMLwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:52:15 -0400
Received: from ozlabs.org ([203.10.76.45]:45893 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759546AbZJMLwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:52:14 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Patchs vs. percpu-next] Use this_cpu_xx to dynamically allocate counters
Date: Tue, 13 Oct 2009 22:21:34 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Tejun Heo <tj@kernel.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
References: <20091001212521.123389189@gentwo.org> <200910062034.40864.rusty@rustcorp.com.au> <alpine.DEB.1.10.0910081355530.7735@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910081355530.7735@gentwo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910132221.35208.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009 04:27:53 am Christoph Lameter wrote:
> On Tue, 6 Oct 2009, Rusty Russell wrote:
> 
> > Does this mean we can kill local.h soon?
> 
> Can we remove local.h from modules?

This looks sweet to me!

Only comment: not sure struct module_ref is required once we have __percpu
markers.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
