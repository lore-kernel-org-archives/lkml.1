Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab0BQXmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 18:42:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33243 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab0BQXmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 18:42:53 -0500
Message-ID: <4B7C7EB3.6000202@zytor.com>
Date: Wed, 17 Feb 2010 15:41:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Yuhong Bao <yuhongbao_386@hotmail.com>
CC: luca@luca-barbieri.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] x86-32: panic on !CX8 && XMM
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com> <1266406962-17463-11-git-send-email-luca@luca-barbieri.com>,<4B7C6FC8.7090107@zytor.com> <SNT125-W19438E1E5A7FB2F02097DEC3480@phx.gbl>
In-Reply-To: <SNT125-W19438E1E5A7FB2F02097DEC3480@phx.gbl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 03:00 PM, Yuhong Bao wrote:
> 
>> NAK in the extreme.
>>
>> This is not how we deal with these kinds of stuff. If this really
>> matters, we explicitly clear the CPU feature in the feature detect code.
> Also, don't forget the NT4 CX8 bug with non-Intel/AMD/Cyrix vendors:
> http://www.geoffchappell.com/studies/windows/km/cpu/cx8.htm
> If a processor support SSE (or PAE or MMX for that matter), you can pretty much assume CX8 exists even if the feature bit is cleared because of this bug.
> 

Those kinds of things we *also* deal with by adjusting the CPU features
in the detection code.

	-hpa
