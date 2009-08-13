Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZHMGt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZHMGt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZHMGt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:49:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52836 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbZHMGt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:49:26 -0400
Date: Thu, 13 Aug 2009 08:48:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joseph Cihula <joseph.cihula@intel.com>, Shane Wang <shane.wang@intel.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       andi@firstfloor.org, chrisw@sous-sol.org, jmorris@namei.org,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com
Subject: Re: [RFC v6][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution
	Technology support for Linux - Details
Message-ID: <20090813064850.GB12143@elte.hu>
References: <4A4ACA60.1000209@intel.com> <20090807072752.GA12119@elte.hu> <20090812145321.GA11347@elte.hu> <4A82DBA2.2000509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A82DBA2.2000509@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> tboot_sleep() references acpi_wakeup_address, which is only 
> defined if CONFIG_ACPI_SLEEP is set.  We *could* make TBOOT 
> require CONFIG_ACPI_SLEEP, but that looks like the wrong thing to 
> do to me, unless TXT somehow depends on having S3 support.

ACPI_SLEEP is set by all generic distros so this isnt a big issue. 
I'd rather have it squeaky clean first, and then if there's any 
request for this to work on !ACPI, we can expand on that.

No strong feelings though. Note that the Kconfig section needs to be 
cleaned up in any case, as per my previous mail.

	Ingo
