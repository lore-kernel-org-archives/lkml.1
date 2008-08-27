Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbYH0Fbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbYH0Fbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 01:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYH0Fbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 01:31:31 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1995 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751690AbYH0Fba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 01:31:30 -0400
Message-ID: <48B4E66C.2080806@myri.com>
Date: Wed, 27 Aug 2008 07:30:20 +0200
From: Brice Goglin <brice@myri.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Dave Airlie <airlied@gmail.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 3/4] x86: PAT Update validate_pat_support for intel CPUs
References: <20080820234550.923970000@intel.com>	 <20080820234604.592277000@intel.com> <21d7e9970808260005g14ec71e9xfa584780498a86e7@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC460B68CC5F@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC460B68CC5F@orsmsx505.amr.corp.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> Default MTRR being UC for all reserved regions and drivers
> wanting WC is very common situation and performance will be
> affected when that ends up being UC access.
> With pat disabled, drivers can set MTRR with WC in this case
> and get the expected performance.
>   

Are you saying that drivers are supposed to check if PAT is disabled
before deciding whether they need to setup a MTRR WC? If so, how to do
we check that? Unless we get a way to know whether ioremap_wc() returned
WC or UC, I will always keep the MTRR WC in myri10ge.

Brice

