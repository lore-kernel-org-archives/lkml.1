Return-Path: <linux-kernel-owner+w=401wt.eu-S933640AbYAaMLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640AbYAaMLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933332AbYAaMKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:10:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60196 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933229AbYAaMKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:10:53 -0500
Date: Thu, 31 Jan 2008 13:10:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: change_page_attr_clear fix
Message-ID: <20080131121035.GC12571@elte.hu>
References: <1201764959.12950.22.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201764959.12950.22.camel@caritas-dev.intel.com>
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


* Huang, Ying <ying.huang@intel.com> wrote:

> This patch replaces __change_page_attr_set_clr() with 
> change_page_attr_set_clr() in change_page_attr_clear() to flush the 
> TLB/cache properly.

thanks, applied. Thomas just found this bug today too :-)

	Ingo
