Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYG1OOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYG1OOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYG1OOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:14:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36873 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbYG1OOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:14:08 -0400
Date: Mon, 28 Jul 2008 16:13:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Wang, Shane" <shane.wang@intel.com>, "Wei, Gang" <gang.wei@intel.com>,
       "Brown, Len" <len.brown@intel.com>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] acpi - Add support for AddressRangeUnusuable ACPI
	memory type
Message-ID: <20080728141353.GD18144@elte.hu>
References: <D936D925018D154694D8A362EEB0892004FC7099@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D936D925018D154694D8A362EEB0892004FC7099@orsmsx416.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Cihula, Joseph <joseph.cihula@intel.com> wrote:

> Add support for the E820_UNUSABLE memory type, which is defined in
> Revision 3.0b (Oct. 10, 2006) of the ACPI Specification on p. 394 Table
> 14-1:
> 	AddressRangeUnusuable
> 	This range of address contains memory in which errors have been
> detected. This range must not be used by the OSPM.
> 
> This patch applies cleanly to 2.6.26.

Looks good to me, but the 32-bit and 64-bit files that this patch 
changes got unified in the latest upstream tree - could you please 
resend this against tip/master:

 http://people.redhat.com/mingo/tip.git/README

thanks,

	Ingo
