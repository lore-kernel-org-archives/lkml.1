Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbXJDCrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbXJDCrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 22:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXJDCrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 22:47:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50257 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751615AbXJDCrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 22:47:02 -0400
Date: Wed, 3 Oct 2007 19:46:52 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, serue@us.ibm.com,
       clg@fr.ibm.com, ebiederm@xmission.com, xemul@openvz.org,
       rientjes@google.com, svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       a.p.zijlstra@chello.nl, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/33] task containersv11 add tasks file interface
Message-Id: <20071003194652.873b0bcf.pj@sgi.com>
In-Reply-To: <6599ad830710030816m32321b54gbc79c24d0a39941b@mail.gmail.com>
References: <20070917210307.116234000@menage.corp.google.com>
	<20070917210426.579524000@menage.corp.google.com>
	<20071003010923.c606c176.pj@sgi.com>
	<6599ad830710030816m32321b54gbc79c24d0a39941b@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >  - There are many instances of the local variable 'cont', referring
> >    to a struct cgroup pointer.  I presume the spelling 'cont' is a
> >    holdover from the time when we called these containers.
> 
> Yes, and since cgroup is short for "control group", "cont" still
> seemed like a reasonable abbreviation. (And made the automatic
> renaming much simpler).

The following will change all 'cont' words to your choice (I doubt
you want to use 'XXXX' as I did here) in cgroup.c:

    sed -i -r 's/(\W|^)cont(\W|$)/\1XXXX\2/g' kernel/cgroup.c

I can't say for sure, but I suspect that if cgroups had always
been cgroups (short for control groups), then these local 'cont'
variables would have a different name.  One can often, as in this
case, find some justification for most any name.  The question is
which name is most quickly and easily understood.

... yes ... I'm a stickler for names ... sorry.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
