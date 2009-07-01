Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbZGAPaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbZGAPaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZGAP3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:29:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35701 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbZGAP3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:29:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090701144913.GA28172@elte.hu>
References: <20090701144913.GA28172@elte.hu> <19019.22629.720187.794661@cargo.ozlabs.ibm.com> <20090701115425.GJ15958@elte.hu> <20090630215437.GB22851@elte.hu> <20090630212454.19294.75622.stgit@warthog.procyon.org.uk> <20090630213406.GB17492@elte.hu> <200906302341.58582.arnd@arndb.de> <22582.1246447691@redhat.com> <32551.1246450797@redhat.com> <32707.1246452087@redhat.com> <30887.1246457403@redhat.com> 
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, Paul Mackerras <paulus@samba.org>,
       Arnd Bergmann <arnd@arndb.de>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Wire up new syscalls
Date: Wed, 01 Jul 2009 16:19:35 +0100
Message-ID: <10833.1246461575@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> Ok, indeed - you can define it to 0 for now - FRV wont set hw counters so it
> doesnt matter.

Okay.  FRV does have some h/w perf counters for measuring various things about
userspace and kernel execution.  I'll have to look at how to use them with
this.

David
