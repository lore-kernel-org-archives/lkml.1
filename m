Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZGAMmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZGAMmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbZGAMmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:42:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43997 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZGAMmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:42:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <19019.22629.720187.794661@cargo.ozlabs.ibm.com>
References: <19019.22629.720187.794661@cargo.ozlabs.ibm.com> <20090701115425.GJ15958@elte.hu> <20090630215437.GB22851@elte.hu> <20090630212454.19294.75622.stgit@warthog.procyon.org.uk> <20090630213406.GB17492@elte.hu> <200906302341.58582.arnd@arndb.de> <22582.1246447691@redhat.com> <32551.1246450797@redhat.com> 
To: Paul Mackerras <paulus@samba.org>
Cc: dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Arnd Bergmann <arnd@arndb.de>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Wire up new syscalls
Date: Wed, 01 Jul 2009 13:41:27 +0100
Message-ID: <32707.1246452087@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras <paulus@samba.org> wrote:

> I did a generic implementation using irq disable on UP and hashed
> spin-locks on SMP.  See 09d4e0ed for the implementation

I can do better than that on FRV.  FRV has load/store-double instructions that
I can use to atomically load/store 64-bit memory locations by using paired
registers for the data.

David
