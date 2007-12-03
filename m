Return-Path: <linux-kernel-owner+w=401wt.eu-S1751524AbXLCPP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbXLCPP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbXLCPPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:15:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbXLCPPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:15:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071111112538.GL21669@stusta.de>
References: <20071111112538.GL21669@stusta.de> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153437.20803.55096.stgit@warthog.procyon.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if !CONFIG_BINFMT_AOUT [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 03 Dec 2007 15:15:29 +0000
Message-ID: <18452.1196694929@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> - it adds #ifdef's in fs/binfmt_elf.c for code that is anyway
>   scheduled for removal in 2.6.25

I'm told (by Ralf) that removing this support will break Castle Wolfenstein or
something like that.

So unless you want hordes of rampaging MIPS users breaking down your door
whilst waving pitchforks and torches, maybe this needs to be reconsidered...

David
