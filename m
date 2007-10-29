Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbXJ2PHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbXJ2PHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXJ2PHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:07:33 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:44487 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323AbXJ2PHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:07:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HALaTJUdMQWvU/2dsb2JhbACBWg
Date: Mon, 29 Oct 2007 11:07:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       "William L. Irwin" <wli@holomorphy.com>
Subject: Re: [patch 05/10] Move profiling to instrumentation
Message-ID: <20071029150729.GA21302@Krystal>
References: <20071029142646.699058449@polymtl.ca> <20071029142940.219544075@polymtl.ca> <20071029075950.3263767f@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071029075950.3263767f@laptopd505.fenrus.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:04:24 up 91 days, 15:23,  4 users,  load average: 0.55, 0.55, 0.77
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> On Mon, 29 Oct 2007 10:26:51 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Move kernel/profile.c to instrumentation/.
> 
> 
> I have one question... can this be done via a git move command so that
> history is properly maintained?
> 

moving kernel/profile.c to instrumentation/profile.c should be done
through a git mv. Moving the Makefile lines should be done through a
patch.

But since I use quilt to manage my patchset, I guess I don't have this
ability. Should I switch to git to perform this change to make
everyone's life easier or should I simply ask kindly for maintainers to
perform git mv in their tree ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
