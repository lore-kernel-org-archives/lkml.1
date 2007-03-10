Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXCJJvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXCJJvj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932080AbXCJJvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:51:38 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:25894 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbXCJJvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:51:37 -0500
Subject: Re: [PATCH] Complain about missing system calls.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Andi Kleen <ak@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sam@ravnborg.org, rmk@arm.linux.org.uk
In-Reply-To: <200703091954.13982.ak@suse.de>
References: <1173394873.3461.510.camel@pmac.infradead.org>
	 <p737itqbdnl.fsf@bingen.suse.de>
	 <1173458854.24454.27.camel@localhost.localdomain>
	 <200703091954.13982.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Sat, 10 Mar 2007 10:51:36 +0100
Message-Id: <1173520296.7128.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 19:54 +0100, Andi Kleen wrote:
> > We need additional gunk for syscalls that can be called from SPEs on
> > cell
> 
> Can that gunk not be auto generated?
> 
> I know s390 does in some cases, but it looks quite auto generatable to me.

The system call tables and the compat wrapper are all manually created.
If we manage to get the prototypes for the system calls in a parseable
format at least the compat wrappers could be auto-generated. I see two
pitfalls: 1) some compat system calls are directly wired to the system
call table while others need the compat_wrapper detour, 2) override of
system calls with "meta" system calls like sys_socket or sys_ipc.

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


