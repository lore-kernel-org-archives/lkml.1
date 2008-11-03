Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbYKCJQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbYKCJQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 04:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbYKCJQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 04:16:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58836 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbYKCJQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 04:16:08 -0500
Date: Mon, 3 Nov 2008 10:15:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
Cc: linux-kernel@vger.kernel.org, glommer@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/6] x86: rename __FIXADDR_SIZE and __FIXADDR_BOOT_SIZE
Message-ID: <20081103091555.GL11730@elte.hu>
References: <1225592633-9948-1-git-send-email-gustavo@las.ic.unicamp.br> <1225592633-9948-2-git-send-email-gustavo@las.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225592633-9948-2-git-send-email-gustavo@las.ic.unicamp.br>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0119]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gustavo F. Padovan <gustavo@las.ic.unicamp.br> wrote:

> Rename __FIXADDR_SIZE to FIXADDR_SIZE
> and __FIXADDR_BOOT_SIZE to FIXADDR_BOOT_SIZE.
> 
> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
> Acked-by: Glauber Costa <gcosta@redhat.com>

ok, the patches look nice. Could you please rework them against 
tip/master? We already have a commit in 
arch/x86/include/asm/fixmap_32.h (the DRM speedup patches) which cause 
rejects.

	Ingo
