Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbXKLMcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbXKLMcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 07:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbXKLMcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 07:32:05 -0500
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:55757 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864AbXKLMcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 07:32:03 -0500
Date: Mon, 12 Nov 2007 12:31:44 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Robert Richter <robert.richter@amd.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/6] x86: apicdef unification: some constants made unsigned
In-Reply-To: <20071106183646.064906000@amd.com>
Message-ID: <Pine.LNX.4.64N.0711121229360.30102@blysk.ds.pg.gda.pl>
References: <20071106183645.951275000@amd.com> <20071106183646.064906000@amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007, Robert Richter wrote:

> -#define			GET_APIC_VERSION(x)	((x)&0xFF)
> -#define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFF)
> -#define			APIC_INTEGRATED(x)	((x)&0xF0)
> +#define			GET_APIC_VERSION(x)	((x)&0xFFu)
> +#define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFFu)
> +#define			APIC_INTEGRATED(x)	((x)&0xF0u)

 No point in doing this -- hexadecimal literals are unsigned by 
definition.  File a compiler bug if you see them interpreted otherwise.

  Maciej
