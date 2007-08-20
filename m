Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbXHTV7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbXHTV7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbXHTV70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:59:26 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:35914 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313AbXHTV70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:59:26 -0400
Date: Mon, 20 Aug 2007 17:54:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [patch 01/23] Fall back on interrupt disable in cmpxchg8b on 80386 and 80486
Message-ID: <20070820215413.GA28452@Krystal>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca> <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com> <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com> <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:54:03 up 21 days, 22:12,  4 users,  load average: 0.29, 0.28, 0.35
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Mon, 20 Aug 2007, Mathieu Desnoyers wrote:
> 
> > I'm digging in the slub with cmpxchg_local patch... first detail:
> > slab_alloc seems to have a return path that does not reenable
> > preemption... I'll keep you posted when I finish the 2.6.23-rc2-mm2
> > port.
> 
> I have a patchset here if that would help you?
> 

Sure, I'd like to give it a try.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
