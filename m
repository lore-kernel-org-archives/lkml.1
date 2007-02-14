Return-Path: <linux-kernel-owner+w=401wt.eu-S1751242AbXBNUrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242AbXBNUrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXBNUrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:47:40 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35962 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573AbXBNUrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:47:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 15/21] Xen-paravirt: Add Xen interface header files
References: <20070213221729.772002682@goop.org>
	<20070213221830.619562494@goop.org>
Date: Wed, 14 Feb 2007 13:45:52 -0700
In-Reply-To: <20070213221830.619562494@goop.org> (Jeremy Fitzhardinge's
	message of "Tue, 13 Feb 2007 14:17:44 -0800")
Message-ID: <m1k5ykpiwv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Add Xen interface header files. These are taken fairly directly from
> the Xen tree and hence the style is not entirely in accordance with
> Linux guidelines. There is a tension between fitting with Linux coding
> rules and ease of maintenance.
>
> Define macros and inline functions for doing hypercalls into the
> hypervisor.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
> Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
>
>
> --
>  include/asm-i386/hypercall.h          |  416 +++++++++++++++++++++++++++++
>  include/asm-i386/hypervisor.h         |   72 +++++

Are hypercall.h and hypervisor.h generic or are they Xen specific.
If they are Xen specific (as it appears) then are inappropriately
named.

>  include/xen/interface/arch-x86_32.h   |  187 +++++++++++++
Why isn't this file include-asm-i386/xen/arch-x86_32.h ?

>  include/xen/interface/elfnote.h       |  133 +++++++++
>  include/xen/interface/event_channel.h |  195 ++++++++++++++
>  include/xen/interface/features.h      |   43 +++
>  include/xen/interface/grant_table.h   |  301 +++++++++++++++++++++
>  include/xen/interface/io/blkif.h      |   96 ++++++
>  include/xen/interface/io/console.h    |   23 +
>  include/xen/interface/io/netif.h      |  152 ++++++++++
>  include/xen/interface/io/ring.h       |  260 ++++++++++++++++++
>  include/xen/interface/io/xenbus.h     |   42 +++
>  include/xen/interface/io/xs_wire.h    |   87 ++++++
>  include/xen/interface/memory.h        |  145 ++++++++++
>  include/xen/interface/physdev.h       |   61 ++++
>  include/xen/interface/sched.h         |   77 +++++
>  include/xen/interface/vcpu.h          |  109 +++++++
>  include/xen/interface/version.h       |   60 ++++
>  include/xen/interface/xen.h           |  445 ++++++++++++++++++++++++++++++++
>  19 files changed, 2904 insertions(+)

Eric
