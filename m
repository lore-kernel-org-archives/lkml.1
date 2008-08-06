Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbYHFFAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbYHFFAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYHFEzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 00:55:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53635 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbYHFEzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 00:55:17 -0400
Message-ID: <48992E5A.3050303@cn.fujitsu.com>
Date: Wed, 06 Aug 2008 12:53:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Max Krasnyansky <maxk@qualcomm.com>
CC: Jeff Chua <jeff.chua.linux@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>	 <48991B07.3050500@qualcomm.com>	 <b6a2187b0808052050h35e2786fwfbf1e1dd5c37d8cf@mail.gmail.com>	 <48992085.3050203@qualcomm.com> <b6a2187b0808052106l1c553df4lab4e9e9f29de356d@mail.gmail.com> <48992D35.9020005@qualcomm.com>
In-Reply-To: <48992D35.9020005@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Krasnyansky wrote:
> Jeff Chua wrote:
>> On Wed, Aug 6, 2008 at 11:54 AM, Max Krasnyansky <maxk@qualcomm.com>
>> wrote:
>>
>>> Are you running 32-bit kernel ?
>>
>> Yes. But, does it matter?
> 
> It used to. 64-bit kernel used to handle maxcpus option as documented in
> the Documentation/cpu-hotplug.txt and 32-bit one was broken.
> I just looked at the latest code and realized that both are now broken.
> They ignore cpu id > maxcpus instead of not-booting them.
> 

Yes. I have an x86_64 box with 4 cpus, but yesterday when I booted up with maxcpus=2,
I didn't see the other 2 cpus.

> I'll send a patch that fixes that tomorrow.
> 

greate :)

