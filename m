Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbZIZSsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbZIZSsb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZIZSsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:48:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:51769 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZIZSsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:48:30 -0400
Date: Sat, 26 Sep 2009 20:48:48 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: prasad@linux.vnet.ibm.com
Cc: "Frank Ch. Eigler" <fche@redhat.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
 get to performance counters
Message-ID: <20090926204848.0b2b48d2@infradead.org>
In-Reply-To: <20090926183246.GA4141@in.ibm.com>
References: <20090925122556.2f8bd939@infradead.org>
	<y0mhbuplmlr.fsf@fche.csb>
	<20090926183246.GA4141@in.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009 00:02:46 +0530
"K.Prasad" <prasad@linux.vnet.ibm.com> wrote:

> On Sat, Sep 26, 2009 at 12:03:28PM -0400, Frank Ch. Eigler wrote:

> > For what it's worth, this sort of thing also looks useful from
> > systemtap's point of view.
> 
> Wouldn't SystemTap be another user that desires support for
> multiple/all CPU perf-counters (apart from hw-breakpoints as a
> potential user)? As Arjan pointed out, perf's present design would
> support only a per-CPU or per-task counter; not both.

I'm sorry but I think I am missing your point.
"all cpu counters" would be one small helper wrapper away, a helper I'm
sure the SystemTap people are happy to submit as part of their patch
series when they submit SystemTap to the kernel.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
