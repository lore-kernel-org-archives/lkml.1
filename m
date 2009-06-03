Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbZFCOJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbZFCOJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbZFCOJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:09:08 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:34004 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753054AbZFCOJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:09:07 -0400
Date: Wed, 3 Jun 2009 10:08:51 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
Subject: Re: [my_cpu_ptr 1/5] Introduce my_cpu_ptr()
In-Reply-To: <200905311249.08107.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0906031006020.15621@gentwo.org>
References: <20090527180635.008102701@gentwo.org> <200905291057.16286.rusty@rustcorp.com.au> <alpine.DEB.1.10.0905291023570.30695@gentwo.org> <200905311249.08107.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 May 2009, Rusty Russell wrote:

> > Hmmm.. That would be a major change in semantics.
>
> It's exactly like get_cpu_var.  For better or worse, let's not invent YA new
> convention.

It hink we are doing that if we go the get_cpu_ptr line. this_cpu_ptr
starts from per_cpu_ptr() and its straightforward as a special case of
per_cpu_ptr.

> So that name question doesn't really have a clear convention answer: we could
> re-use cpu_local_inc() since I think we decided to kill local_t.  I slightly
> prefer it over "this_cpu_*" since we're not actually doing anything to the cpu
> itself, but I don't think anyone will get too confused and think that after
> this executes their CPU will be stepping 11. :)

local is loaded with meaning by glibc where it means thread local. The
variables here are cpu specific, not task specific.

