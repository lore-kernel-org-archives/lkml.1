Return-Path: <linux-kernel-owner+w=401wt.eu-S935927AbYD1RO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935927AbYD1RO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933789AbYD1ROq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:14:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57747 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776AbYD1ROp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:14:45 -0400
Message-ID: <481605CD.7030807@zytor.com>
Date: Mon, 28 Apr 2008 10:13:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] x86: Modify Kconfig to allow up to 4096 cpus
References: <20080426001548.829332000@polaris-admin.engr.sgi.com> <20080426001549.014201000@polaris-admin.engr.sgi.com> <20080427103933.GA5168@ucw.cz> <20080428133806.GC3973@elte.hu> <20080428135459.GA3704@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080428135459.GA3704@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> * Pavel Machek <pavel@ucw.cz> wrote:
>>
>>> On Fri 2008-04-25 17:15:49, Mike Travis wrote:
>>>>   * Increase the limit of NR_CPUS to 4096 and introduce a boolean
>>>>     called "MAXSMP" which when set (e.g. "allyesconfig"), will set
>>>>     NR_CPUS = 4096 and NODES_SHIFT = 9 (512).
>>> Why is redundant option 'maxsmp' a good idea?
>> because this way randconfig can trigger it and can configure all the 
>> otherwise randconfig-invisible [or just plain unlikely] numerics and 
>> options up to their max.
>>
>> I found 2-3 "large box" bugs via that way already.
> 
> Should we improve randconfig to select numeric values when range is
> given, too?
> 								Pavel

Would not be a bad idea; preferrably with a logarithmic distribution.

	-hpa
