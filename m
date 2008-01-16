Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbYAPDL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbYAPDL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 22:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbYAPDLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 22:11:51 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:31985 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYAPDLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 22:11:51 -0500
Date: Tue, 15 Jan 2008 22:11:49 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: add is_f00f_bug helper to fault_32|64.c
Message-ID: <20080116031149.GA14210@phobos.i.cabal.ca>
References: <1200451715.16794.71.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200451715.16794.71.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 06:48:35PM -0800, Harvey Harrison wrote:
> +#ifdef CONFIG_X86_F00F_BUG
> +void do_invalid_op(struct pt_regs *, unsigned long);
> +#endif
> +
> +static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
> +{
> +#ifdef CONFIG_X86_F00F_BUG
> +	unsigned long nr;

You can just put the prototype inside the function, you know...
