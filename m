Return-Path: <linux-kernel-owner+w=401wt.eu-S965447AbXAWVQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965447AbXAWVQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 16:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965452AbXAWVQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 16:16:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965447AbXAWVQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 16:16:17 -0500
Date: Tue, 23 Jan 2007 16:16:12 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Define the EF_AS_NO_RANDOM e_flag bit
Message-ID: <20070123211612.GJ29911@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <87r6toufpp.wl@betelheise.deep.net> <200701221520.l0MFKLdK032645@turing-police.cc.vt.edu> <871wlnq7ue.wl@betelheise.deep.net> <20070123084805.GB5560@ucw.cz> <87mz4996wg.wl@betelheise.deep.net> <20070123154127.57059632@localhost.localdomain> <877ivd8p42.wl@betelheise.deep.net> <20070123205017.GH29911@devserv.devel.redhat.com> <874pqh8nbu.wl@betelheise.deep.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874pqh8nbu.wl@betelheise.deep.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 12:06:45AM +0300, Samium Gromoff wrote:
> Should we introduce per-arch asm/elf.h files to hold the relevant flag definitions then?

On some architectures there are no bits left.  On others you'd need to go
through whomever maintains the relevant psABI to get a bit officially
allocated.  Really, it is very bad idea to use e_flags for this.

If all you care about is running setuid LISP programs, you'd much better put
your energy into fixing the buggy ELF dumper in it.

	Jakub
