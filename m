Return-Path: <linux-kernel-owner+w=401wt.eu-S935210AbZJOSdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935210AbZJOSdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935062AbZJOSdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:33:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40049 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935056AbZJOSdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:33:07 -0400
Message-ID: <4AD76A5A.4050806@zytor.com>
Date: Thu, 15 Oct 2009 11:30:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ian Lance Taylor <iant@google.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: linker script syntax nits
References: <20091014221024.EFA79E2F@magilla.sf.frob.com>	<20091015033010.GB10068@merkur.ravnborg.org>	<20091015063837.GA11645@elte.hu>	<4AD75920.8000303@zytor.com> <20091015182616.DFD875E6@magilla.sf.frob.com>
In-Reply-To: <20091015182616.DFD875E6@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2009 11:26 AM, Roland McGrath wrote:
>> The other -- and somewhat less cantankerous way -- is to use a dummy symbol:
>>
>> #define LINUX_ASSERT(expr, name, string) name = ASSERT(expr, string)
>>
>> "name" would have to be unique for each instance.
> 
> I wouldn't like to pollute the symtabs with those useless symbols.
> 
> #define LINUX_ASSERT(expr, string) PROVIDE(_assert_bogon = ASSERT(expr, string))
> 
> works with a recent ld.  I don't know what the problematic old ld versions
> were.  Do you have such on hand to test?
> 
> Ian may have another suggestion.
> 

I don't remember how old they have to be... I think RHEL 4 timeframe,
though.

	-hpa
