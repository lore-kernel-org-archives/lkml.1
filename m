Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbXKGUlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbXKGUlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 15:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbXKGUlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 15:41:24 -0500
Received: from gw.goop.org ([64.81.55.164]:54198 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbXKGUlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 15:41:23 -0500
Message-ID: <473222E5.7020808@goop.org>
Date: Wed, 07 Nov 2007 12:41:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/6] x86: apicdef unification: some constants made unsigned
References: <20071106183645.951275000@amd.com> <20071106183646.064906000@amd.com>
In-Reply-To: <20071106183646.064906000@amd.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> -#define			GET_APIC_VERSION(x)	((x)&0xFF)
> -#define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFF)
> -#define			APIC_INTEGRATED(x)	((x)&0xF0)
> +#define			GET_APIC_VERSION(x)	((x)&0xFFu)
> +#define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFFu)
> +#define			APIC_INTEGRATED(x)	((x)&0xF0u)

Can these ever be used in .S files?  Might be better to use the _AC stuff.

    J
