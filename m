Return-Path: <linux-kernel-owner+w=401wt.eu-S1761875AbXEQWRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761875AbXEQWRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761194AbXEQWRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:17:07 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:34939 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761026AbXEQWRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:17:06 -0400
Message-ID: <464CD45A.6090902@simon.arlott.org.uk>
Date: Thu, 17 May 2007 23:16:58 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Claas Langbehn <claas@rootdir.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: This kernel requires the following features not present on the
 CPU... (on a VIA C7 CPU)
References: <464C4A22.7040709@rootdir.de> <464CB726.6090201@simon.arlott.org.uk> <464CB7CC.8030706@zytor.com>
In-Reply-To: <464CB7CC.8030706@zytor.com>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/05/07 21:15, H. Peter Anvin wrote:
> Simon Arlott wrote:
>> Is it automatic? I have CONFIG_X86_CMPXCHG=y without cx8 showing in
>> cpuinfo, and it appears to work fine.
>>
>> Will your changes needlessly prevent the kernel running? Would I be
>> right in thinking that the kernel is successfully using cmpxchg even
>> though it's considered disabled? I realise people compile kernels for
>> the wrong CPU but preventing them working when it's been chosen
>> correctly seems wrong.
>>
> 
> CX8 isn't cmpxchg; it's cmpxchg8b.

Ok, but I have CONFIG_X86_CMPXCHG64=y too.

-- 
Simon Arlott
