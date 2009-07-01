Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbZGAMUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbZGAMUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbZGAMUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:20:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50200 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZGAMUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:20:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090701115425.GJ15958@elte.hu>
References: <20090701115425.GJ15958@elte.hu> <20090630215437.GB22851@elte.hu> <20090630212454.19294.75622.stgit@warthog.procyon.org.uk> <20090630213406.GB17492@elte.hu> <200906302341.58582.arnd@arndb.de> <22582.1246447691@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, Arnd Bergmann <arnd@arndb.de>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Wire up new syscalls
Date: Wed, 01 Jul 2009 13:19:57 +0100
Message-ID: <32551.1246450797@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> [ There might be unanticipated problems of course - please report to
>   us any problems (tools/perf/ does not build cleanly, features dont
>   work as expected, etc.). ]

It requires atomic64_t.  Is that mandatory on all arches now?

David
