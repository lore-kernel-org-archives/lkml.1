Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbYCZHK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbYCZHK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 03:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbYCZHKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 03:10:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYCZHKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:10:18 -0400
Date: Wed, 26 Mar 2008 08:09:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: Re: [PATCH 16/20] x86: align to clflush size
Message-ID: <20080326070925.GJ18301@elte.hu>
References: <1206480999-21767-8-git-send-email-gcosta@redhat.com> <1206480999-21767-9-git-send-email-gcosta@redhat.com> <1206480999-21767-10-git-send-email-gcosta@redhat.com> <1206480999-21767-11-git-send-email-gcosta@redhat.com> <1206480999-21767-12-git-send-email-gcosta@redhat.com> <1206480999-21767-13-git-send-email-gcosta@redhat.com> <1206480999-21767-14-git-send-email-gcosta@redhat.com> <1206480999-21767-15-git-send-email-gcosta@redhat.com> <1206480999-21767-16-git-send-email-gcosta@redhat.com> <1206480999-21767-17-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206480999-21767-17-git-send-email-gcosta@redhat.com>
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

>  	/* no easy way to get cache size on all x86, so return the
>  	 * maximum possible, to be safe */
> -	return (1 << INTERNODE_CACHE_SHIFT);
> +	return boot_cpu_data.x86_clflush_size;

please update the comment too. (just add a delta patch to your next 
series)

	Ingo
