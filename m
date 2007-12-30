Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbXL3O1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbXL3O1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXL3O1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:27:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36116 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbXL3O1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:27:03 -0500
Date: Sun, 30 Dec 2007 15:23:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: export 'leave_mm' symbol
Message-ID: <20071230142324.GL16946@elte.hu>
References: <200712281658.05958.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712281658.05958.mboton@gmail.com>
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


* Miguel Botón <mboton.lkml@gmail.com> wrote:

> This patch fixes a linking error if CONFIG_ACPI_PROCESSOR=m (this 
> error occurs in the 'mm' branch of linux-2.6-x86.git).
> 
> We need to export the 'leave_mm' symbol so it can be accessible for 
> the ACPI processor module.

ok - i've added this as EXPORT_SYMBOL_GPL() - this is strictly for 
kernel internal use.

	Ingo
