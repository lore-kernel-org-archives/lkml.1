Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbYBHWLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbYBHWLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbYBHWIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:08:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760856AbYBHWIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:08:37 -0500
Message-ID: <47ACD2D2.2000105@redhat.com>
Date: Fri, 08 Feb 2008 17:08:18 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] x86: Use FIX_EFLAGS define in X86_64
References: <1202501399.12966.24.camel@brick>
In-Reply-To: <1202501399.12966.24.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2008 03:09 PM, Harvey Harrison wrote:
> +#ifdef CONFIG_X86_32
> +#define	FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_RF | X86_EFLAGS_OF | \
> +			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
> +			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
> +			 X86_EFLAGS_CF)
> +#else
> +#define	FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
> +			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
> +			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
> +			 X86_EFLAGS_CF)
> +#endif

A comment about some of these would be nice... like what this bitmask is for...
