Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbZKMHRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbZKMHRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 02:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZKMHRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 02:17:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35584 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZKMHRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 02:17:31 -0500
Message-ID: <4AFD07F0.70602@zytor.com>
Date: Thu, 12 Nov 2009 23:17:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH RFC] x86: fix confusing name of /proc/cpuinfo "ht" flag
References: <200911112134.34261.bzolnier@gmail.com> <20091112065930.GA9279@elte.hu> <4AFBB45A.9000606@zytor.com> <20091112081317.GB25345@elte.hu> <4AFC274C.2020209@zytor.com> <20091112175908.GB20542@elte.hu>
In-Reply-To: <20091112175908.GB20542@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2009 09:59 AM, Ingo Molnar wrote:
>>
>> No, please.  We have had people who have "helpfully" tried to change 
>> /proc/cpuinfo in the past, and what we find is that application 
>> developers don't tell us -- they grumble among themselves and put out 
>> a new release saying "fixes breakage introduced by Linux ..."
>>
>> It's an ABI.  Keep it stable, please.
> 
> That's generally true, but i'm not suggesting that: i'm suggesting to 
> _clear_ the HT flag from the cpufeatures if there's only one sibling. 
> It's meaningless in that case and as the link quoted by the original 
> patch shows many people are confused by that.
> 
> I have such a box so i can test it. (but i dont expect any problems)
> 

Ah, okay, that makes more sense.  Someone else in the tread wanted to
rename the flag.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

