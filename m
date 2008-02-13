Return-Path: <linux-kernel-owner+w=401wt.eu-S932973AbYBMJaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbYBMJaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbYBMJah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:30:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32840 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760440AbYBMJae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:30:34 -0500
Date: Wed, 13 Feb 2008 10:29:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Matt Mackall <mpm@selenic.com>, Linux-tiny@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] x86: Configure out compilation of Simple Boot
	Flag support
Message-ID: <20080213092958.GB25258@elte.hu>
References: <20080213094400.6b7f3446@crazy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213094400.6b7f3446@crazy>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> -	acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf);
> +	acpi_table_parse(ACPI_SIG_BOOT, sbf_acpi_parse);

no strong feelings if the ACPI guys ack it - but i suspect the renaming 
of the function from acpi_parse_sbf to sbf_acpi_parse was unnecessary?

	Ingo
