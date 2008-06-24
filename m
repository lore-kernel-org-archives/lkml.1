Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbYFXKZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbYFXKZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYFXKZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:25:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbYFXKZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:25:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080623174809.GE4756@cs181140183.pp.htv.fi>
References: <20080623174809.GE4756@cs181140183.pp.htv.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk, cooloney@kernel.org,
       dev-etrax@axis.com, gerg@uclinux.org, yasutake.koichi@jp.panasonic.com,
       linux-parisc@vger.kernel.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-sh@vger.kernel.org, chris@zankel.net, linux-mips@linux-mips.org,
       ysato@users.sourceforge.jp, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm/ptrace.h userspace headers cleanup
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 24 Jun 2008 11:23:48 +0100
Message-ID: <8058.1214303028@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> This patch contains the following cleanups for the asm/ptrace.h 
> userspace headers:
> - include/asm-generic/Kbuild.asm already lists ptrace.h, remove
>   the superfluous listings in the Kbuild files of the following
>   architectures:
> ...
>   - frv
> ...
> - don't expose function prototypes and macros to userspace:
> ...
>   - mn10300

Acked-by: David Howells <dhowells@redhat.com> (FRV and MN10300)
