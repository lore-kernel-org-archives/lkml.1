Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbYE3KBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbYE3KBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 06:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYE3KBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 06:01:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40777 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752998AbYE3KBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 06:01:31 -0400
Date: Fri, 30 May 2008 10:46:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Jackson <pj@sgi.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, miaox@cn.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       menage@google.com
Subject: Re: [RFC] [PATCH 1/2] cpusets: restructure the function
 update_cpumask() and update_nodemask()
Message-ID: <20080530104658.26a3783f@core>
In-Reply-To: <20080530012537.87454a8d.pj@sgi.com>
References: <483E564A.5050807@cn.fujitsu.com>
	<20080529031656.cdc38001.pj@sgi.com>
	<483F5DAA.5060004@cn.fujitsu.com>
	<20080529205344.4ba1efdb.pj@sgi.com>
	<483F6367.1040701@cn.fujitsu.com>
	<20080529212211.0e794c81.pj@sgi.com>
	<20080529203042.19f76f09.rdunlap@xenotime.net>
	<20080529225708.74f65654.pj@sgi.com>
	<20080529212746.2d9cae24.rdunlap@xenotime.net>
	<20080530012537.87454a8d.pj@sgi.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have never seen or heard of a document using the "/**" kernel-doc
> entries of kernel/cpuset.c, and I have no idea who actually has (in
> the past or present, not just hypothetically) read such or why.

People wanting to generate things like function lists.

> being a stubborn retard, I continue to prefer that file static routines
> in kernel/cpuset.c not have "/**" kernel-doc markers on their comments,
> and I would still welcome a patch from Miao removing the ones already
> there.

And I'll join that by stubbonly NAKing such an approach. We want
consistent clear formats for documentation extraction. Simply getting
people to use the kerneldoc format materially improves the documentation
quality, so please don't set bad examples ;)

Alan

