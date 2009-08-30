Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbZH3Ut2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbZH3Ut2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 16:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZH3Ut2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 16:49:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51831 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbZH3Ut1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 16:49:27 -0400
Message-ID: <4A9AE5B1.80305@zytor.com>
Date: Sun, 30 Aug 2009 13:48:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 3/3] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM
 CPUID bit
References: <1251633031-2244-1-git-send-email-petkovbb@gmail.com> <1251633031-2244-3-git-send-email-petkovbb@gmail.com> <4A9AD17A.6060507@zytor.com> <20090830193039.GB22234@liondog.tnic> <4A9ADAC3.3020004@zytor.com> <20090830202926.GC22234@liondog.tnic>
In-Reply-To: <20090830202926.GC22234@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2009 01:29 PM, Borislav Petkov wrote:
> 
> Ok, what do we want actually? We have rdmsr_safe and rdmsrl_safe where
> the last one engineers the 2 u32s into a u64. My gut feeling would opt
> for the 2 32bit values instead of one 64bit since they're naturally
> returned into %eax:%edx. And in the most cases we need only one of the
> values. However, the MSRs themselves are 64bit... Hmmm...
> 

The 2x32 bit interface is the legacy interface.  It turned out to be a
bad idea, but it's hard to clean up all the users.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

