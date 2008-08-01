Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYHAOE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYHAOE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 10:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYHAOEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 10:04:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbYHAOEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 10:04:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080728150521.GD16555@linux-sh.org>
References: <20080728150521.GD16555@linux-sh.org> <20080728150359.GA16555@linux-sh.org> <20080728150430.GB16555@linux-sh.org> <20080728150501.GC16555@linux-sh.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] binfmt_elf_fdpic: Wire up AT_EXECFD, AT_EXECFN, AT_SECURE.
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Fri, 01 Aug 2008 15:04:15 +0100
Message-ID: <27598.1217599455@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt <lethal@linux-sh.org> wrote:

> These auxvec entries are the only ones left unhandled out of the current
> base implementation. This syncs up binfmt_elf_fdpic with linux/auxvec.h
> and current binfmt_elf.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Acked-by: David Howells <dhowells@redhat.com>

Though I'm not sure bprm->exec is any use in NOMMU circumstances:-/
