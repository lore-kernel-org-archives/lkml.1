Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYGMUdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYGMUdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 16:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYGMUdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 16:33:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40905 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbYGMUdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 16:33:10 -0400
Date: Sun, 13 Jul 2008 22:32:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCh] x86: overmapped fix when 4K pages on tail - 64bit
Message-ID: <20080713203250.GA6925@elte.hu>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807080143.27997.yhlu.kernel@gmail.com> <200807092015.03004.yhlu.kernel@gmail.com> <20080710071640.5035cd70@infradead.org> <874p6t25n5.fsf@basil.nowhere.org> <86802c440807131117g3ba9e61chea61af81b7537bb0@mail.gmail.com> <487A4DFC.5090701@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487A4DFC.5090701@firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > with this patch, my 256g system still use gbpages for 1g-3g, 4g-256g
> 
> 256GB certainly qualifies as "large system". But as Linus always says: 
> Linux is not for servers only. Ignoring the small systems makes you 
> look bad.

Yinghai is hard at work fixing long-time crappiness of the x86 memory 
setup code on 32-bit and 64-bit x86 alike. Contrary to your suggestion 
he has not been "ignoring small systems" in any way - he has done the 
exact opposite: Yinghai has fixed a ton of small-system bugs and 
usability annoyances along the way.

Your attempt trying to cast this much-needed cleanup, fixing and 
robustization effort into a negative light is as pityful as it is wrong.

	Ingo
