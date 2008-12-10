Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYLJKjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYLJKjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 05:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbYLJKji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 05:39:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58984 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922AbYLJKjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 05:39:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200812071951.18907.rusty@rustcorp.com.au>
References: <200812071951.18907.rusty@rustcorp.com.au> <200812051855.07203.rusty@rustcorp.com.au> <2204.1228478296@redhat.com> <200812052325.22974.rusty@rustcorp.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] param: Adapt MN10300 to the new parameter handling regime
Date: Wed, 10 Dec 2008 10:39:31 +0000
Message-ID: <4093.1228905571@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> > > It should, perhaps,
> > > appear in /proc/cmdline, but for some reason it does not.
> > 
> > Hmm, that's more concering.  I'll dig into this in the morning.
> 
> OK, I can't reproduce it.  I was thinking some weird corner case
> with not restoring the string in parse_args, but putting in a dummy
> "mem" core_param() on x86 works as first, middle and last arg on cmdline,
> and command line shows up correctly in /proc/cmdline.
> 
> Any chance I can ask you to verify that?  Is the commandline printk'd
> on boot also wrong?

I think I must've tested it wrong, probably by forgetting to paste in a mem=
option on the kernel command line when I was trying to check /proc/cmdline.
Leastways, it works now.

David
