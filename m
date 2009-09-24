Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbZIXRWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbZIXRWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZIXRWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:22:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbZIXRWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:22:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090924113342.6031.82407.stgit@warthog.procyon.org.uk>
References: <20090924113342.6031.82407.stgit@warthog.procyon.org.uk> <20090924113332.6031.11718.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: [PATCH 3/4] NOMMU: Make it possible to get the per-task stack usage through /proc for NOMMU
Date: Thu, 24 Sep 2009 18:20:14 +0100
Message-ID: <20511.1253812814@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Make it possible to get the per-task stack usage through /proc on a NOMMU
> system.  This is required because walk_page_range() doesn't work on NOMMU.
> 
> 	# grep "Stack usage:" /proc/*/status
> 	/proc/1/status:Stack usage:	2 kB
> 	/proc/56/status:Stack usage:	2 kB
> 	/proc/57/status:Stack usage:	1 kB
> 	/proc/58/status:Stack usage:	2 kB
> 	/proc/59/status:Stack usage:	5 kB
> 	/proc/self/status:Stack usage:	1 kB
> 
> I've only tested it with ELF-FDPIC, though it should work with FLAT too.

Ignore this patch, please.  It only works for single-threaded processes.

David
