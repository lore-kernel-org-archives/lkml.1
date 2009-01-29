Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbZA2MVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbZA2MVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 07:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbZA2MVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 07:21:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51448 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbZA2MVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 07:21:16 -0500
Date: Thu, 29 Jan 2009 13:20:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stable Kernel <stable@kernel.org>,
       "dan.magenheimer@oracle.com" <dan.magenheimer@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] xen: make sysfs files behave as their names suggest
Message-ID: <20090129122059.GB9588@elte.hu>
References: <4980FD4C.3030700@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4980FD4C.3030700@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> 1: make "target_kb" only accept and produce a memory size in kilobytes.
> 2: add a second "target" file which produces output in bytes, and will accept
>   memparse input (scaled bytes)
>
> This fixes the rather irritating problem that writing the same value
> read back into target_kb would end up shrinking the domain by a factor
> of 1024, with generally bad results.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> drivers/xen/balloon.c |   33 ++++++++++++++++++++++++++++++++-
> 1 file changed, 32 insertions(+), 1 deletion(-)

applied to tip/x86/urgent, thanks Jeremy!

	Ingo
