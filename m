Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbYLHOKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbYLHOKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:10:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYLHOJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:09:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45594 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbYLHOJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:09:54 -0500
Date: Mon, 8 Dec 2008 15:09:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup get_smp_config
Message-ID: <20081208140938.GF29965@elte.hu>
References: <493A1F9E.4010201@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493A1F9E.4010201@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: cleanup
> 
> reordering exit path in __get_smp_config
> also move two print out to acpi_process_madt
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/acpi/boot.c |   11 +++++++++++
>  arch/x86/kernel/mpparse.c   |   25 +++++++++++--------------
>  2 files changed, 22 insertions(+), 14 deletions(-)

applied to tip/x86/quirks, thanks Yinghai!

	Ingo
