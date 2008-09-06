Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbYIFPqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbYIFPqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 11:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYIFPqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 11:46:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40582 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbYIFPqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 11:46:16 -0400
Date: Sat, 6 Sep 2008 17:45:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, pageexec@freemail.hu,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080906154551.GB1774@elte.hu>
References: <20080903195122.73905236@infradead.org> <48C0FF43.30940.2C3EFC0@pageexec.freemail.hu> <1220609647.4879.169.camel@pasglop> <48C10EC5.24400.3008276@pageexec.freemail.hu> <1220612231.4879.175.camel@pasglop> <20080905114233.GA27878@elte.hu> <20080905204134.GI19337@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905204134.GI19337@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> Then they will simply proceed like this :
>   - patch /boot/vmlinuz
>   - sync
>   - crash system
> 
> => user says "oh crap" and presses the reset button. Patched kernel boots.
>    Game over. Patching vmlinuz for known targetted distros is even easier
>    because the attacker just has to embed binary changes for the most
>    common distro kernels.

a reboot often raises attention. But yes, in terms of end user boxes, 
probably not. Anyway, my points were about transparent rootkits 
installed on a running system without anyone noticing - obviously if the 
attacker can modify the kernel image and the user does not mind a reboot 
it's game over.

	Ingo
