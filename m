Return-Path: <linux-kernel-owner+w=401wt.eu-S1763471AbYJJVbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763471AbYJJVbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759960AbYJJVbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:31:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45006 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759310AbYJJVbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:31:20 -0400
Message-ID: <48EFC9A0.5070907@zytor.com>
Date: Fri, 10 Oct 2008 14:31:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [update5] [PATCH] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200809090641.m896fscX028849@hitchhiker.org.lu> <48C99F29.2030007@zytor.com> <48C9A6C0.4070802@knaff.lu> <48C9A80D.1010703@zytor.com> <48D73858.3070900@knaff.lu> <48D7C304.4020709@zytor.com> <48D7C48F.8010907@knaff.lu> <48D93E68.6040701@zytor.com> <48D9471E.9090108@knaff.lu> <48D95A8F.10705@zytor.com> <48D95ECC.9010107@knaff.lu> <48D96013.1070507@zytor.com> <48D966E4.7080200@knaff.lu> <48D96B58.6080604@zytor.com> <48D96C60.6000104@knaff.lu> <48EE4302.2010404@zytor.com> <48EEC7D1.80404@knaff.lu>
In-Reply-To: <48EEC7D1.80404@knaff.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> H. Peter Anvin wrote:
>> Hi Alain,
>>
>> Are you planning to submit an updated patch any time soon?  If so,
>> please separate the ARM, x86, library and generic portions into separate
>> patches.  It looks like at least some of them already went into ARM,
>> which makes it impractical to include this as a monolithic patch, which
>> it really shouldn't have to be, anyway.
>>
>>     -hpa
> 
> I'll look into it (the split) this weekend, if I'll find the time.
> Should each part be compilable on its own? If so, it might be difficult
> to do the split along the lines outlined above.
> 

Not individually, but part 1 should compile, as should parts 1+2, etc.

This pretty much means the order should be:

1. add library functions
2. generic functionality
3. x86 functionality
4. ARM functionality

Soem of these may be obsolete; I noticed collisions with the ARM tree.

	-hpa
