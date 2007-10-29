Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbXJ2Xp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbXJ2Xp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbXJ2XpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:45:17 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:56679 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093AbXJ2XpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:45:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAJYNJkdMQWvU/2dsb2JhbACBWg
Date: Mon, 29 Oct 2007 19:40:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>
Subject: Re: [RFC] Create instrumentation directory (git repository)
Message-ID: <20071029234012.GB19413@Krystal>
References: <20071029215138.GA4233@Krystal> <Pine.LNX.4.64.0710291619210.4821@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710291619210.4821@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:35:48 up 91 days, 23:54,  3 users,  load average: 0.45, 0.81, 0.71
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Mon, 29 Oct 2007, Mathieu Desnoyers wrote:
> 
> > vm/vmstat.c
> 
> The vm statistics are important for the operation of the VM. They are not 
> optional. So I do not think that they fall under the category of 
> instrumentation.

But I guess vm stats can be useful to others; a kernel tracer for
instance ?

Putting stuff in instrumentation/ by no way means that it becomes
optional for a subsystem, but merely that it could either export
information useful for kernel instrumentation or have some
infrastructure parts merged with others. 

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
