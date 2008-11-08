Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbYKHLkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbYKHLkf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 06:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYKHLk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 06:40:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33829 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbYKHLk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 06:40:26 -0500
Date: Sat, 8 Nov 2008 12:40:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH 1/1] x86_64: update address space documentation
Message-ID: <20081108114010.GA8354@elte.hu>
References: <1226139897-15070-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226139897-15070-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0029]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> Commit a6523748bddd38bcec11431f57502090b6014a96
> (paravirt/x86, 64-bit: move __PAGE_OFFSET to leave a space for hypervisor)
> changed address space without changing the documentation. Change it
> according to the code change -- direct mapping start:
> ffff810000000000 => ffff880000000000 which gives 57 TiB, something between
> 45 and 46 bits.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> ---
>  Documentation/x86/x86_64/mm.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip/x86/doc, thanks Jiri!

	Ingo
