Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbYGVFLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbYGVFLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYGVFK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:10:56 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:58238 "EHLO
	pd7mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750906AbYGVFKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:10:55 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=M129IYPnjNFOM3OtMLcA:9 a=0jRhGKjl3yt6t6WaQLzWKQ53i4UA:4 a=MSl-tDqOz04A:10 a=l9iCJtgIvv4A:10 a=GFZTb6icBPAA:10
Message-ID: <48856BC6.7030308@sieb.net>
Date: Mon, 21 Jul 2008 22:10:30 -0700
From: Samuel Sieb <samuel@sieb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.15) Gecko/20080706 Fedora/1.1.10-1.fc9 pango-text SeaMonkey/1.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Rafael C. de Almeida" <almeidaraf@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
References: <48841A92.4020301@sieb.net> <48842E71.9070503@gmail.com> <20080721114752.GE23095@elte.hu>
In-Reply-To: <20080721114752.GE23095@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rafael C. de Almeida <almeidaraf@gmail.com> wrote:
> 
>> Samuel Sieb wrote:
>>> I have a computer here with a CPU that the BIOS identifies as:
>>> Cyrix MediaGXm/Cx5530 Unicorn Revision 1.19.3B
>>>
>>> I can't boot any kernel later than 2.6.22 on it.  Anything later either
>>> hangs or gives random kernel panics while booting.  I tracked down the
>>> problem to a specific commit:
>>>
>>> commit f25f64ed5bd3c2932493681bdfdb483ea707da0a
> does the debug patch below (ontop of v2.6.26 or later kernels) make the 
> system bootable again? Commit f25f64ed5 changed the meaning of that 
> line. This patch switches back to the old behavior (which essentially 
> did nothing, due to macro side-effect bugs).
> 
Commenting out this line didn't have any effect that I could see.  I was 
hoping one way or another it would affect the TSC unstable message I 
get, but it didn't even change that.
