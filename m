Return-Path: <linux-kernel-owner+w=401wt.eu-S1751474AbXCUL4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbXCUL4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbXCUL4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:56:14 -0400
Received: from ozlabs.org ([203.10.76.45]:58632 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbXCUL4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:56:13 -0400
Subject: Re: [PATCH 2/4] i386 GDT cleanups: Use per-cpu GDT immediately
	upon boot
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <m1aby7c59k.fsf@ebiederm.dsl.xmission.com>
References: <1174457426.11680.132.camel@localhost.localdomain>
	 <1174458636.11680.143.camel@localhost.localdomain>
	 <1174458730.11680.145.camel@localhost.localdomain>
	 <1174458938.11680.150.camel@localhost.localdomain>
	 <m1aby7c59k.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 22:55:53 +1100
Message-Id: <1174478153.11680.183.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 03:31 -0600, Eric W. Biederman wrote:
> Rusty Russell <rusty@rustcorp.com.au> writes:
> > -/*
> > - * The boot_gdt_table must mirror the equivalent in setup.S and is
> > - * used only for booting.
> > - */
> 
> It looks like you are killing a useful comment here for no good reason.

Hi Eric,

	I think one has to look harder, then.  There is no "equivalent in
setup.S": there is no setup.S, and it's certainly not clear what GDT
this "must mirror": it doesn't mirror any GDT at the moment.

	This leaves us with "is only used for booting".  The name
"boot_gdt_table" and the code itself are pretty clear.

	A comment might well deserve to live here, but not this one 8)

Hope that clarifies,
Rusty.

