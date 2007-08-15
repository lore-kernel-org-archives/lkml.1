Return-Path: <linux-kernel-owner+w=401wt.eu-S1765523AbXHOOst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765523AbXHOOst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761034AbXHOOsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:48:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:56969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761026AbXHOOsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:48:40 -0400
Date: Wed, 15 Aug 2007 17:42:44 +0200
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/25][V3] irq_flags / halt routines
Message-ID: <20070815154243.GH3406@bingen.suse.de>
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com> <11871822163867-git-send-email-gcosta@redhat.com> <20070815135554.GE3406@bingen.suse.de> <5d6222a80708150718v14f26343q7467385e7919fa76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6222a80708150718v14f26343q7467385e7919fa76@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 11:18:25AM -0300, Glauber de Oliveira Costa wrote:
> > Didn't we agree this should be a pvops client?
> >
> > -Andi
> >
> No. I exposed my reasoning, asked you back, but got no answer.
> I'll do it again:
> 
> This operations are just manipulating bits, and are doing no
> privileged operations at all. Nothing that can be paravirtualized, in

It's talking to a Hypervisor. That is privileged enough.
Please do that change. If you add so many more ifdefs it's your
duty to keep the overall number low.

Various other paravirt ops also do things which are not strictly
privileged.

-Andi
