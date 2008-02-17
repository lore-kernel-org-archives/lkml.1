Return-Path: <linux-kernel-owner+w=401wt.eu-S1751187AbYBQSGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbYBQSGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYBQSGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:06:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52182 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbYBQSGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:06:10 -0500
Date: Sun, 17 Feb 2008 19:05:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, ak@suse.de,
       chrisw@sous-sol.org, kiran@scalemp.com, shai@scalemp.com
Subject: Re: [PATCH 4/5] [PATCH] introduce paravirt helpers
Message-ID: <20080217180509.GW6006@elte.hu>
References: <1202757365-18634-1-git-send-email-gcosta@redhat.com> <1202757365-18634-2-git-send-email-gcosta@redhat.com> <1202757365-18634-3-git-send-email-gcosta@redhat.com> <1202757365-18634-4-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202757365-18634-4-git-send-email-gcosta@redhat.com>
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

>  config X86_VSMP
>  	bool "Support for ScaleMP vSMP"
>  	depends on X86_64 && PCI
> -	 help
> +	select PARAVIRT
> +	help

hm, what's the idea here?

	Ingo
