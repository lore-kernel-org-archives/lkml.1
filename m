Return-Path: <linux-kernel-owner+w=401wt.eu-S1751666AbZGNRbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbZGNRbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbZGNRbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:31:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51036 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZGNRbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:31:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1247591665-12000-1-git-send-email-vapier@gentoo.org>
References: <1247591665-12000-1-git-send-email-vapier@gentoo.org> <20090714161416.GA19147@cmpxchg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Bernd Schmidt <bernds_cb1@t-online.de>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v2] NOMMU: add support for Memory Protection Units (MPU)
Date: Tue, 14 Jul 2009 18:22:06 +0100
Message-ID: <6206.1247592126@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> Some architectures (like the Blackfin arch) implement some of the
> "simpler" features that one would expect out of a MMU such as memory
> protection.  In our case, we actually get read/write/exec protection
> down to the page boundary so processes can't stomp on each other let
> alone the kernel.  There is a performance decrease (which depends greatly
> on the workload) however as the hardware/software interaction was not
> optimized at design time.

It occurs to me that I could probably test this on FRV by using the MMU in a
limited way.  How do you actually keep track of the protections applied?  Do
you have a single global page table that is managed by the mmap code on a
per-VMA basis?

David
