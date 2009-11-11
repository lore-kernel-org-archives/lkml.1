Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbZKKHs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbZKKHs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbZKKHs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:48:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47254 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525AbZKKHs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:48:58 -0500
Date: Wed, 11 Nov 2009 08:48:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] x86: make sure wakeup code is below 1M -v2
Message-ID: <20091111074830.GA10310@elte.hu>
References: <4AF7D820.5040503@kernel.org>
 <200911091315.13151.rjw@sisk.pl>
 <4AFA210B.3020207@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFA210B.3020207@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> try to find_e820_area/reserve_early, and call acpi_reserve_memory early
> 
> to get area is below 1M
> 
> -v2: change function name to acpi_reserve_wakeup_memory according to Rafael
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/acpi.h  |    2 +-
>  arch/x86/kernel/acpi/sleep.c |   15 +++++++++------
>  arch/x86/kernel/setup.c      |   13 +++++++------
>  3 files changed, 17 insertions(+), 13 deletions(-)

Looks good. Rafael, Peter, does it look good to you too?

	Ingo
