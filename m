Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbXIUM63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbXIUM63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXIUM6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:58:22 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:42702 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbXIUM6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:58:21 -0400
Date: Fri, 21 Sep 2007 08:58:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, dsmith@redhat.com,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070921125819.GA13129@Krystal>
References: <20070918211324.161373216@polymtl.ca> <20070919113737.GA18177@Krystal> <y0mtzpqvk1l.fsf@ton.toronto.redhat.com> <200709192132.00873.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200709192132.00873.vda.linux@googlemail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:57:50 up 53 days, 13:16,  4 users,  load average: 2.14, 1.52, 1.02
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Denys Vlasenko (vda.linux@googlemail.com) wrote:
> On Wednesday 19 September 2007 14:53, Frank Ch. Eigler wrote:
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> > 
> > > [...]  Do you think I should also remove the __markers_strings
> > > section from here ?
> > 
> > Current systemtap marker support code relies on the __markers_strings
> > section.
> 
> Let users know that in comment above section definition in ld script.
> 

Ok, I am changing it to:


        /* Markers: strings (used by SystemTAP) */                      \
        __markers_strings : AT(ADDR(__markers_strings) - LOAD_OFFSET) { \
                *(__markers_strings)                                    \
        }                                                               \

Mathieu

> Thanks!
> --
> vda

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
