Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbYBQSFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYBQSFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYBQSF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:05:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57774 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbYBQSF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:05:27 -0500
Date: Sun, 17 Feb 2008 19:04:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, ak@suse.de,
       chrisw@sous-sol.org, kiran@scalemp.com, shai@scalemp.com
Subject: Re: [PATCH 3/5] [PATCH] call vsmp_init explicitly
Message-ID: <20080217180425.GV6006@elte.hu>
References: <1202757365-18634-1-git-send-email-gcosta@redhat.com> <1202757365-18634-2-git-send-email-gcosta@redhat.com> <1202757365-18634-3-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202757365-18634-3-git-send-email-gcosta@redhat.com>
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


* Glauber Costa <gcosta@redhat.com> wrote:

> --- a/arch/x86/kernel/setup_64.c
> +++ b/arch/x86/kernel/setup_64.c
> @@ -346,6 +346,10 @@ #endif
>  	if (efi_enabled)
>  		efi_init();
>  
> +#ifdef	CONFIG_PARAVIRT
> +	vsmp_init();
> +#endif

that #ifdef should be in setup.h, instead of polluting a .c file with 
it.

	Ingo
