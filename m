Return-Path: <linux-kernel-owner+w=401wt.eu-S1761242AbYFMNLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761242AbYFMNLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 09:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbYFMNLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 09:11:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790AbYFMNLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 09:11:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080612221143.GR17231@cs181133002.pp.htv.fi>
References: <20080612221143.GR17231@cs181133002.pp.htv.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] mn10300: export kernel_thread
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 13 Jun 2008 14:11:16 +0100
Message-ID: <29145.1213362676@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> --- a/arch/mn10300/kernel/mn10300_ksyms.c
> +++ b/arch/mn10300/kernel/mn10300_ksyms.c

Why put it here?  It should really go with the definition of kernel_thread()
in arch/mn10300/kernel/process.c.

I've just posted my own patch to deal with this and empty_zero_page.  I also
submitted an additional patch to provide __ucmpdi2() so that allmodconfig
builds for me.

David
