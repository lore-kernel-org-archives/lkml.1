Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbYDZPiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbYDZPiD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbYDZPhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:37:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:42592 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbYDZPhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:37:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=VP6ybDk3LFrGXcvsswr3S+w7+bq3TBlCP/LfUJLBqxiX9BC6Y+yFg1kpapSV9tSD/uGxHhy/61amGdT2FHyqYCrehhtoIBgDHsdzwCPAF6cCKW1NLRK8J4Y3r2w0Wz4Clu8VOEZyUn/wGymphHkvhviGCq3oG/P3DHZgWm2yvz4=
Message-ID: <48134C45.806@googlemail.com>
Date: Sat, 26 Apr 2008 17:37:41 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] x86 PAT changes
References: <20080424225625.GB8717@elte.hu> <481330C6.7040109@googlemail.com> <20080426144203.GA19635@elte.hu>
In-Reply-To: <20080426144203.GA19635@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>> Hi Ingo,
>>
>> When using an 64bit ( didn't got time to test 32bit now ) kernel[1] 
>> with PAT enabled , kvm-intel does not work anymore.
>>
>> When modprobing kvm-intel , kvm is saying VT extension is disable by 
>> BIOS which isn't true. When disabling PAT again ( no changes to BIOS ) 
>> kvm-intel works again here.
>>
>> Is that an known problem ?
> 
> no, that side-effect was not known. Cc:-ed more folks.

It seems like the update triggers some compiler bug.

Setting CC_OPTIMIZE_FOR_SIZE=n fixed that btw. 

I don't have the time right now but later on today I will compile 
gcc43_svn_branch and test again with CC_OPTIMIZE_FOR_SIZE=y and see what I get.

Ingo sorry for the noise.

Gabriel
