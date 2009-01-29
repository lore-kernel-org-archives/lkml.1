Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbZA2Irm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbZA2Irm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZA2Ird
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:47:33 -0500
Received: from ozlabs.org ([203.10.76.45]:34687 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZA2Ird (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:47:33 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 4 of 7] x86/paravirt: selectively save/restore regs around pvops calls
Date: Thu, 29 Jan 2009 19:17:25 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>,
       Ravikiran Thirumalai <kiran@scalemp.com>
References: <patchbomb.1233182100@abulafia.goop.org> <5849eb6475c1bbe5a6ca.1233182104@abulafia.goop.org>
In-Reply-To: <5849eb6475c1bbe5a6ca.1233182104@abulafia.goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291917.26601.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009 09:05:04 Jeremy Fitzhardinge wrote:
> +#define PV_SAVE_REGS(set)			\
> +	COND_PUSH(set, CLBR_RAX, rax);		\
> +	COND_PUSH(set, CLBR_RCX, rcx);		\
> +	COND_PUSH(set, CLBR_RDX, rdx);		\
> +	COND_PUSH(set, CLBR_RSI, rsi);		\
> +	COND_PUSH(set, CLBR_RDI, rdi);		\
> +	COND_PUSH(set, CLBR_R8, r8);		\
> +	COND_PUSH(set, CLBR_R9, r9);		\
> +	COND_PUSH(set, CLBR_R10, r10);		\
> +	COND_PUSH(set, CLBR_R11, r11)

It's kind of messy.  Can we do something clever here with token pasting?

Cheers,
Rusty.
