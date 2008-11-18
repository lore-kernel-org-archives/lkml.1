Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYKRPMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYKRPMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYKRPM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:12:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45069 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbYKRPM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:12:26 -0500
Date: Tue, 18 Nov 2008 16:12:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Philipp Kohlbecher <xt28@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: more general identifier for Phoenix BIOS
Message-ID: <20081118151222.GG30358@elte.hu>
References: <491EEDE8.5080508@gmx.de> <491F7D88.7080403@zytor.com> <20081116072300.GB19646@elte.hu> <491FFFC5.9080006@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491FFFC5.9080006@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Philipp Kohlbecher <xt28@gmx.de> wrote:

> Phoenix BIOSes variously identify their vendor as "Phoenix Technologies,  
> LTD" or "Phoenix Technologies LTD" (without the comma.)
>
> This patch makes the identification string in the bad_bios_dmi_table  
> more general (following a suggestion by Ingo Molnar), so that both  
> versions are handled.
>
> Again, the patched file compiles cleanly and the patch has been tested  
> successfully on my machine.
>
> Signed-off-by: Philipp Kohlbecher <xt28@gmx.de>

applied to tip/x86/urgent, thanks Philipp!

I also tagged it for -stable backporting.

>> Note that we should do a simpler patch: just change the string to 
>> "Phoenix Technologies" and that will provide a proper match. (DMI 
>> matches work on substrings too)
>
> Done. (I wasn't sure whether you were saying that *I* should write 
> this simpler patch or that you would. Anyway, here it is.)

yeah, developers/users writing patches is always the preferred 
solution! It's the vector that spreads Linux development to new areas 
and new people.

	Ingo
