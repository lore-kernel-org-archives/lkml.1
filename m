Return-Path: <linux-kernel-owner+w=401wt.eu-S1764976AbXEUPql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764976AbXEUPql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763747AbXEUPqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:46:22 -0400
Received: from outbound-mail-08.bluehost.com ([69.89.17.208]:33971 "HELO
	outbound-mail-08.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763603AbXEUPqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:46:20 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
Subject: Re: [PATCH 4/8] Force detect and enable HPET on ICH
Date: Mon, 21 May 2007 08:46:03 -0700
User-Agent: KMail/1.9.6
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>
References: <20070507203128.GD3926@linux-os.sc.intel.com> <20070521025822.506c3287@laptop.hypervisor.org>
In-Reply-To: <20070521025822.506c3287@laptop.hypervisor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705210846.03540.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 20, 2007, Udo A. Steinberg wrote:
> On Mon, 7 May 2007 13:31:28 -0700 Venki Pallipadi (VP) wrote:
>
> VP> Force detect and/or enable HPET on ICH chipsets. This patch just
> handles the VP> detection part and following patches use this
> information.
> VP>
> VP> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>
> Venki,
>
> Is there any reason your patch only enables HPET on ICH6 and beyond?
> HPET can be enabled on earlier ICH by setting bit 17 in GEN_CNTL on PCI
> dev 31, func 0, offset d0. This seems to work for ICH3/4/5. Are there
> any errata affecting these ICHs?

I see it documented in the ICH5 datasheet, but that bit is marked reserved 
in the ICH3 and ICH4 datasheets...  Which docs are you looking at?

Jesse
