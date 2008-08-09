Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbYHIOIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbYHIOIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 10:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYHIOHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 10:07:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbYHIOHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 10:07:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1218287473.3155.13.camel@dhcppc0>
References: <1218287473.3155.13.camel@dhcppc0> <1218281190.3155.5.camel@dhcppc0> <1218214935.3146.5.camel@dhcppc0> <alpine.LRH.1.10.0808090747150.29079@tundra.namei.org> <14476.1218286327@redhat.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>
Subject: Re: next-20080808: bash: fork: Resource temporarily unavailable
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Sat, 09 Aug 2008 15:07:06 +0100
Message-ID: <15386.1218290826@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer <thomas@m3y3r.de> wrote:

> Is that what you wanted to know? Doesn't look like a memory leak for me.

It wasn't really what I was after, but I agree, with only 24.4 MB allocated to
slabs, it doesn't look like a leak.

> kmem: invalid structure member offset: kmem_cache_objects
>       FILE: memory.c  LINE: 13500  FUNCTION: dump_kmem_cache_slub()

That smacks of the internal structs having changed more recently than F9's
kmem program.

I guess I need to get this thing running on an i386 box.

David
