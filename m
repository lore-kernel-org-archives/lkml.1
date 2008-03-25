Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbYCYXHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbYCYXHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbYCYXHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:07:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36050 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbYCYXHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:07:22 -0400
Message-ID: <47E98572.704@zytor.com>
Date: Tue, 25 Mar 2008 16:06:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com
Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
References: <200803242324.35357.yhlu.kernel@gmail.com>	 <47E9003B.5010002@zytor.com>	 <86802c440803251103taf4c8f2mb674c3d17f3c2345@mail.gmail.com>	 <20080325190851.GC30998@linux-os.sc.intel.com>	 <20080325200830.GB15330@elte.hu> <47E962AE.9040307@zytor.com>	 <47E9843A.1060702@zytor.com> <86802c440803251605w7021b60cmbc312eb9ca87d277@mail.gmail.com>
In-Reply-To: <86802c440803251605w7021b60cmbc312eb9ca87d277@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>
>>  By the way, I want to clarify: I didn't mean it was *intended* as
>>  vendor-lockin, just that it's an undesirable effect of this.
> 
> if the PAT works, we may need to trim the memory according to MTRR, right?
> 

That doesn't seem like it's specific to PAT?

	-hpa
