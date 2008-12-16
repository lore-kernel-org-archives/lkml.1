Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbYLPVGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbYLPVGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 16:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbYLPVGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:06:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33934 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520AbYLPVGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:06:12 -0500
Date: Tue, 16 Dec 2008 22:06:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Philipp Kohlbecher <xt28@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: documentation fix regarding boot protocol
Message-ID: <20081216210601.GL14787@elte.hu>
References: <49454749.2030901@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49454749.2030901@gmx.de>
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


* Philipp Kohlbecher <xt28@gmx.de> wrote:

> Documentation/x86/boot.txt describes payload_offset as the offset
> from the end of the real-mode code. In fact, it is more accurately
> described as the offset from the beginning of the protected-mode
> code, as (a) this is how it is actually calculated and (b) the padding
> after the real-mode code is not included in the offset.
>
> Signed-off-by: Philipp Kohlbecher <xt28@gmx.de>
>
> ---
>
>  Documentation/x86/boot.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

applied to tip/x86/doc, thanks!

	Ingo
