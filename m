Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbZEKSRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbZEKSRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZEKSRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:17:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54323 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbZEKSRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:17:07 -0400
Message-ID: <4A086B58.30607@zytor.com>
Date: Mon, 11 May 2009 11:15:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: Addition of cpufeatures to friendly access
 miscellaneous MSRs
References: <1242058494.5139.7.camel@ht.satnam>
In-Reply-To: <1242058494.5139.7.camel@ht.satnam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> 
> Jaswinder Singh Rajput (15):
>       x86: Add cpufeature for Processor Name
>       x86: Add cpufeatures for Advanced Power Management
>       x86: Add cpufeature for Microcode update
>       x86: Add cpufeature for Cache MSRs
>       x86: Add cpufeature for Hard and Soft Poweron configuration
>       x86: Add cpufeature for Scaleable bus speed
>       x86: Add cpufeature for Miscellaneous Features
>       x86: Add cpufeature for Platform feature
>       x86: Add cpufeature for Hardware configuration
>       x86: Add cpufeature for System configuration
>       x86: Add cpufeature for System management mode (SMM)
>       x86: Add cpufeature for MM configuration
>       x86: Add cpufeature for Bus configuration
>       x86: Add cpufeature for performance frequency APERF/MPERF
>       x86: Add cpufeature for ancient performance monitoring
> 

Overall, I'm rather confused what the point of this is supposed to be. 
There is value to centralizing CPU knowledge, but some of these flags 
are only used in one place, and as far as I can see in several of your 
patches they aren't used *at all*.

If there is no in-kernel user there is absolutely no point to this.

	-hpa
