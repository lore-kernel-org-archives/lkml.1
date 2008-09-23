Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbYIWLEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbYIWLEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYIWLEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:04:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbYIWLEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:04:45 -0400
Date: Tue, 23 Sep 2008 13:04:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 3/4] x86: Add UV partition call
Message-ID: <20080923110430.GC29021@elte.hu>
References: <20080922211011.GF222374@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922211011.GF222374@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.3 required=5.9 tests=BAYES_20,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.3
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0785]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russ Anderson <rja@sgi.com> wrote:

> +u8 sn_partition_id;
> +EXPORT_SYMBOL(sn_partition_id);
> +u8 uv_coherency_id;
> +EXPORT_SYMBOL(uv_coherency_id);
> +u8 uv_type;
> +EXPORT_SYMBOL(uv_type);

hm, what module uses this? And why not a _GPL export?

	Ingo
