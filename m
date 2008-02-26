Return-Path: <linux-kernel-owner+w=401wt.eu-S1761549AbYBZL2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761549AbYBZL2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 06:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYBZL2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 06:28:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59894 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbYBZL2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 06:28:31 -0500
Date: Tue, 26 Feb 2008 12:28:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86/: switch to proc_create()
Message-ID: <20080226112815.GA10996@elte.hu>
References: <20080226102332.GC7469@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226102332.GC7469@localhost.sw.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0474]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@sw.ru> wrote:

> +	proc_create("apm", 0, NULL, &apm_file_ops);

> +	    proc_create("mtrr", S_IWUSR | S_IRUGO, &proc_root, &mtrr_fops);

thanks, applied.

	Ingo
