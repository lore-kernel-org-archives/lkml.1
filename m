Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbZFWH6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbZFWH6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZFWH6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:58:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41132 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbZFWH6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:58:31 -0400
Date: Tue, 23 Jun 2009 09:58:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 8/8] SFI: expose IO-APIC routines to SFI, not just ACPI
Message-ID: <20090623075815.GD6397@elte.hu>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com> <5ee3ec9f54201bf40549672017dc0a7880cb67b0.1245740912.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ee3ec9f54201bf40549672017dc0a7880cb67b0.1245740912.git.len.brown@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0011]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> From: Feng Tang <feng.tang@intel.com>
> 
> change condition from
> 	#ifdef CONFIG_ACPI
> to
> 	#if defined(CONFIG_ACPI) || defined(CONFIG_SFI)

Please ivent a properly named helper Kconfig entry that expresses 
that condition, instead of uglifying the source code.

Thanks,

	Ingo
