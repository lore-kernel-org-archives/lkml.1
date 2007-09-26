Return-Path: <linux-kernel-owner+w=401wt.eu-S1759046AbXIZLct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbXIZLct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbXIZLcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:32:41 -0400
Received: from ns1.suse.de ([195.135.220.2]:46015 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbXIZLck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:32:40 -0400
From: Andreas Schwab <schwab@suse.de>
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: LKML <linux-kernel@vger.kernel.org>, balbir@in.ibm.com, jlan@engr.sgi.com
Subject: Re: [PATCH] Since we have counters in __u64 format we have to print them with %llu macros.
References: <20070926143918.6749.53939.stgit@localhost.localdomain>
X-Yow: I'll take ROAST BEEF if you're out of LAMB!!
Date: Wed, 26 Sep 2007 13:32:35 +0200
In-Reply-To: <20070926143918.6749.53939.stgit@localhost.localdomain> (Maxim
	Uvarov's message of "Wed\, 26 Sep 2007 14\:39\:18 +0000")
Message-ID: <je641x64rw.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Uvarov <muvarov@ru.mvista.com> writes:

> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
> index cbee3a2..73924df 100644
> --- a/Documentation/accounting/getdelays.c
> +++ b/Documentation/accounting/getdelays.c
> @@ -208,7 +208,7 @@ void print_delayacct(struct taskstats *t)
>  void task_context_switch_counts(struct taskstats *t)
>  {
>  	printf("\n\nTask   %15s%15s\n"
> -	       "       %15lu%15lu\n",
> +	       "       %15llu%15llu\n",
>  	       "voluntary", "nonvoluntary",
>  	       t->nvcsw, t->nivcsw);

__u64 is not always long long.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
