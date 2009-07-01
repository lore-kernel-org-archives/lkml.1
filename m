Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbZGAMhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbZGAMhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZGAMg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:36:57 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:40975 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbZGAMg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:36:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19019.22629.720187.794661@cargo.ozlabs.ibm.com>
Date: Wed, 1 Jul 2009 22:36:53 +1000
From: Paul Mackerras <paulus@samba.org>
To: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
       torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Wire up new syscalls
In-Reply-To: <32551.1246450797@redhat.com>
References: <20090701115425.GJ15958@elte.hu>
	<20090630215437.GB22851@elte.hu>
	<20090630212454.19294.75622.stgit@warthog.procyon.org.uk>
	<20090630213406.GB17492@elte.hu>
	<200906302341.58582.arnd@arndb.de>
	<22582.1246447691@redhat.com>
	<32551.1246450797@redhat.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells writes:

> It requires atomic64_t.  Is that mandatory on all arches now?

I did a generic implementation using irq disable on UP and hashed
spin-locks on SMP.  See 09d4e0ed for the implementation and c2e95c6d
for an example of how to wire it up.

Paul.
