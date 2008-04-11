Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbYDKPvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbYDKPvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760086AbYDKPu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:50:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759639AbYDKPu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:50:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1207927166.22001.91.camel@brick>
References: <1207927166.22001.91.camel@brick> <1207885132.22001.85.camel@brick> <15208.1207908688@redhat.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] kernel: Move arches to use common unaligned access
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 11 Apr 2008 16:50:50 +0100
Message-ID: <2225.1207929050@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Consistency with every other arch..no other reason.

But not M68K(NOMMU), Alpha, Blackfin, Cris, H8300, MN10300, ..., but generally
consistent with the other FRV headers (some other people have added differ).

Hmmm...  It looks like MIPS is weird.  That says __ASM_GENERIC_UNALIGNED_H,
which is probably wrong.

David
