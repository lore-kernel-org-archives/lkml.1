Return-Path: <linux-kernel-owner+w=401wt.eu-S939315AbXGSRE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939315AbXGSRE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934857AbXGSREs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:04:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933756AbXGSREq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:04:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070719165646.GA18436@elte.hu>
References: <20070719165646.GA18436@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] afs: build fix
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Thu, 19 Jul 2007 18:04:35 +0100
Message-ID: <5293.1184864675@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> -	if (posix_test_lock(file, fl) == 0) {
> +	posix_test_lock(file, fl);
> +	if (fl->fl_type == F_UNLCK) {

Yep.  Andrew Morton already has a patch of this form.

David
