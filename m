Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbXD0KAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbXD0KAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbXD0KAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:00:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548AbXD0KAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:00:51 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 11/25] xen: Xen SMP guest support
Date: Fri, 27 Apr 2007 11:10:34 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Benjamin LaHaise <bcrl@kvack.org>,
       Ingo Molnar <mingo@redhat.com>
References: <20070423215638.563901986@goop.org> <200704251124.48445.ak@suse.de> <46319C3B.2010300@goop.org>
In-Reply-To: <46319C3B.2010300@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704271110.34373.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2007 08:46:19 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> >> +/* VCPUs are single-cored, and have no siblings */
> >> +static void set_cpu_sibling_map(int cpu)
> >>     
> >
> > Can you put this somewhere generic and use it everywhere? Don't want
> > duplication of this code.
> >   
> 
> Are there any other users?  This is a very cutdown version of the code
> in kernel/smpboot.c; under Xen all CPUs are considered to be
> single-cored and single-threaded, so there's not a lot to do here.

I would like to have a single place to set that up, with xen calling
it with single arguments and the normal code with complex ones

-Andi
