Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbXDONF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbXDONF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 09:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXDONF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 09:05:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60403 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbXDONF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 09:05:27 -0400
Date: Sun, 15 Apr 2007 15:05:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Clean up mutex_trylock noise
Message-ID: <20070415130521.GB4312@elte.hu>
References: <20070415125444.4f06f233@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415125444.4f06f233@hyperion.delvare>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jean Delvare <khali@linux-fr.org> wrote:

> Ingo Molnar's semaphore to mutex conversions left some noise on a few 
> trylock calls. Clean it up.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>

> -	if (!!mutex_trylock(&zr->resource_lock)) {
> +	if (mutex_trylock(&zr->resource_lock)) {

> -	if (!!mutex_trylock(&mtd_table_mutex)) {
> +	if (mutex_trylock(&mtd_table_mutex)) {

> -	if (!!mutex_trylock(&mtd_table_mutex)) {
> +	if (mutex_trylock(&mtd_table_mutex)) {

thanks! That's one of the side-effects of scripted conversions :-/

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
