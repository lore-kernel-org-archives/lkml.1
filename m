Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZHUBxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZHUBxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 21:53:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZHUBxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 21:53:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40515 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZHUBxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 21:53:00 -0400
Message-ID: <4A8DFD92.3060502@zytor.com>
Date: Thu, 20 Aug 2009 18:51:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Alex Chiang <achiang@hp.com>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
References: <1250276831.3077.17.camel@sbs-t61.sc.intel.com> <20090814192730.GA6431@ldl.fc.hp.com> <1250279799.3077.41.camel@sbs-t61.sc.intel.com> <20090819210251.GD13061@ldl.fc.hp.com> <1250794594.2754.10.camel@sbs-t61.sc.intel.com> <20090820205425.GF13061@ldl.fc.hp.com> <20090820210342.GC29994@basil.fritz.box> <20090820212024.GG13061@ldl.fc.hp.com> <1250803577.2754.30.camel@sbs-t61.sc.intel.com> <4A8DC349.5060508@zytor.com> <20090821003232.GD29994@basil.fritz.box>
In-Reply-To: <20090821003232.GD29994@basil.fritz.box>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2009 05:32 PM, Andi Kleen wrote:
>> I agree... if this ID is used for topology detection, we shouldn't
>> replace it arbitrarily with information from BIOS just to hope that it
>> matches the motherboard stencil.  *Furthermore*, there is no reason why
>> motherboard stencilAs are purely numeric... consider the rather obvious
>> case of two rows of four CPUs; they may have CPU slots labelled A1, A2,
>> A3, A4, B1, B2, B3, B4.  It might very well be the right thing to
>> support arbitrary strings for platforms we recognize.
> 
> Maintaining a manual mapping to strings in the kernel to such strings 
> would be just crazy. You would need a new entry for basically
> every system.
> 
> The reason to correct SOCKETID is that it it is output on errors.
> If it is numerical and you know it's wrong you can correct it,
> and then you can identify the right CPU. Otherwise you lose.
> 

You're not making any sense.  You seem to imply that restricting it to a
numerical ID makes it somehow easier, but it's *the same problem*.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

