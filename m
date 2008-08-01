Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYHAN5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYHAN5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbYHAN5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:57:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbYHAN5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:57:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080728150430.GB16555@linux-sh.org>
References: <20080728150430.GB16555@linux-sh.org> <20080728150359.GA16555@linux-sh.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] binfmt_elf_fdpic: Support auxvec base platform string.
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Fri, 01 Aug 2008 14:57:01 +0100
Message-ID: <27519.1217599021@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt <lethal@linux-sh.org> wrote:

> +	nitems = 1 + DLINFO_ITEMS + (k_platform ? 1 : 0) + \
> +		(k_base_platform ? 1 : 0) + AT_VECTOR_SIZE_ARCH;

Why the backslash?

David
