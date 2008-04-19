Return-Path: <linux-kernel-owner+w=401wt.eu-S1762068AbYDSVF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762068AbYDSVF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 17:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756515AbYDSVFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 17:05:14 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:42712 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756107AbYDSVFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 17:05:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0FAB/7CUhMROPA/2dsb2JhbACBYKh3
Date: Sat, 19 Apr 2008 17:00:10 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
Message-ID: <20080419210010.GB1554@Krystal>
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal> <20080417201410.GB31616@Krystal> <87od889m44.fsf@basil.nowhere.org> <20080418000634.GB5062@Krystal> <480856BD.3080903@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <480856BD.3080903@firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:58:38 up 50 days, 17:09,  4 users,  load average: 0.23, 0.31,
	0.30
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Mathieu Desnoyers wrote:
> > * Andi Kleen (andi@firstfloor.org) wrote:
> >> Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:
> >>> It allows placing immediate values (and therefore optimized trace_marks) in NMI
> >>> code
> >> Only if all your trace_mark infrastructure is lock less.
> >>
> >> -Andi
> >>
> > 
> > It uses RCU-style updates and has been designed to be lockless from the
> > ground up.
> 
> Wrong. If it causes vmalloc faults it is not lockless.
> 
> -Andi
> 

Could you point me where vmalloc_fault accesses a data structure for
which updates are protected by disabling interrupts ? I am curious.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
