Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbZJBRRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbZJBRRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbZJBRRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:17:03 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:39016 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753645AbZJBRRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:17:01 -0400
Date: Fri, 2 Oct 2009 13:11:54 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@elte.hu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 01/20] Introduce this_cpu_ptr() and generic
 this_cpu_* operations
In-Reply-To: <20091002093453.GA21427@elte.hu>
Message-ID: <alpine.DEB.1.10.0910021311440.26189@gentwo.org>
References: <20091001212521.123389189@gentwo.org> <20091001212557.773205427@gentwo.org> <20091002093453.GA21427@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009, Ingo Molnar wrote:

> > @@ -66,6 +69,8 @@ extern void setup_per_cpu_areas(void);
> >  #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu_var(var)))
> >  #define __get_cpu_var(var)			per_cpu_var(var)
> >  #define __raw_get_cpu_var(var)			per_cpu_var(var)
> > +#define this_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
> > +#define __this_cpu_ptr(ptr) this_cpu_ptr(ptr)
>
> Small detail: please have a look at the existing vertical alignment
> style of the code there and follow it with new entries.

Ok. Fixed.

