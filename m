Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbYLENIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbYLENIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYLENHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:07:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42709 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757945AbYLENH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:07:28 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200812052325.22974.rusty@rustcorp.com.au>
References: <200812052325.22974.rusty@rustcorp.com.au> <200812051855.07203.rusty@rustcorp.com.au> <20081203163207.13965.56517.stgit@warthog.procyon.org.uk> <2204.1228478296@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] param: Adapt MN10300 to the new parameter handling regime
Date: Fri, 05 Dec 2008 13:07:23 +0000
Message-ID: <10830.1228482443@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> > With that, the core_param stuff does work for mem=...  But I object to
> > mem_override not being __initdata.  I also don't think the parameter should
> > appear in sysfs - that's just a waste of resources.
> 
> If you set the perm to 0, then it won't appear in sys, and hence can be
> __initdata.

That seemed to work.

David
