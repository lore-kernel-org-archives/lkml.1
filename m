Return-Path: <linux-kernel-owner+w=401wt.eu-S1759236AbYCTWZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbYCTWZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbYCTWYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:24:55 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:46485 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbYCTWYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:24:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As4EAByB4kdMQWoK/2dsb2JhbACBWql7
Date: Thu, 20 Mar 2008 18:24:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jon Masters <jcm@jonmasters.org>,
       Jon Masters <jcm@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] Markers Support for Proprierary Modules
Message-ID: <20080320222453.GB15511@Krystal>
References: <20080320002737.918213455@polymtl.ca> <20080320002835.384758480@polymtl.ca> <20080320191205.GA13309@elte.hu> <y0mzlst6tgi.fsf@ton.toronto.redhat.com> <20080320220540.GA29012@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080320220540.GA29012@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:23:52 up 20 days, 18:34,  6 users,  load average: 0.82, 0.81,
	0.80
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Frank Ch. Eigler <fche@redhat.com> wrote:
> 
> > Ingo Molnar <mingo@elte.hu> writes:
> > 
[...]
> > > [if the proprietary modules attach to kernel markers ...] then all 
> > > the pressure is on those who _can_ fix their code - meaning the 
> > > kernel subsystem maintainers that use [you mean: define] markers.
> > 
> > (In a way, it would be a nice problem to have.  At this moment, there 
> > are still no markers actually committed within -mm nor -linus.)
> 
> ... which makes it doubly problematic to expose them to binary-only 
> modules in any way, shape or form. Really, once _any_ kernel facility is 
> used by such a module, it's pain for us to change it from that point on. 
> Once markers are a 10 year concept that nobody in their right mind would 
> want to change, sure, we dont _care_ about whether it's export or not, 
> and basic courtesy might say that it's OK to do it. But to proactively 
> export any aspect of a half-done piece of infrastructure is crazy.
> 
> 	Ingo

I agree with you on this : maybe it would be better to wait a bit and
let the core markers in first and learn from that before we open this up
to proprierary modules.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
