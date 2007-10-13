Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbXJNAYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbXJNAYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 20:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXJNAYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 20:24:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38544 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbXJNAYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 20:24:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64N.0710121633480.21684@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0710121633480.21684@blysk.ds.pg.gda.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] frv: Remove duplicate output of .exit.data
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Sat, 13 Oct 2007 10:17:51 +0100
Message-ID: <21428.1192267071@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  When CONFIG_DEBUG_INFO is unset the input .exit.data sections are copied 
> twice to vmlinux.  Remove the copy made to .init.text and keep one in 
> .data only.

No, they aren't.  I believe the linker only makes one copy of each section,
and once a copy is inserted, all other attempts to make a copy of it are
ignored.

NAK.

David
