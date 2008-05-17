Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbYEQTXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbYEQTXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 15:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbYEQTW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 15:22:57 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:52847 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbYEQTW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 15:22:56 -0400
Date: Sat, 17 May 2008 15:22:55 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Adrian Bunk <bunk@kernel.org>
Cc: kyle@parisc-linux.org, matthew@wil.cx, grundler@parisc-linux.org,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: parisc setup_sigcontext32() array overflows
Message-ID: <20080517192255.GB6540@phobos.i.cabal.ca>
References: <20080517191636.GA8140@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080517191636.GA8140@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 10:16:37PM +0300, Adrian Bunk wrote:
> setup_sigcontext32(struct compat_sigcontext __user *sc, struct compat_regfile __user * rf, 
>                 struct pt_regs *regs, int in_syscall)            
> {
> ...
>                 /* Store upper half */
>                 compat_reg = (compat_uint_t)(regs->gr[32] >> 32);
> ...                                                   ^^
>                 /* Store upper half */
>                 compat_reg = (compat_uint_t)((regs->gr[32]+4) >> 32);
> ...                                                    ^^
> 
> <--  snip  -->

Yeah, I've already fixed these, was waiting for an ack from the author.

r, Kyle
