Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbYG1SBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbYG1SBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761332AbYG1R7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:59:10 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:25183 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760930AbYG1R7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:59:08 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=ta5PbOrD6259nOntzTEA:9 a=LWHKpjwJIp_VRYmLL_IMtxH9HX4A:4 a=NFhwgSV09UQA:10 a=l9iCJtgIvv4A:10 a=GFZTb6icBPAA:10
Message-ID: <488E08C4.20809@sieb.net>
Date: Mon, 28 Jul 2008 10:58:28 -0700
From: Samuel Sieb <samuel@sieb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.15) Gecko/20080706 Fedora/1.1.10-1.fc9 SeaMonkey/1.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Juergen Beisert <jbe@pengutronix.de>, linux-kernel@vger.kernel.org,
       "Rafael C. de Almeida" <almeidaraf@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Magnus Damm <magnus@valinux.co.jp>, takada <takada@mbf.nifty.com>
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
References: <48841A92.4020301@sieb.net> <48856BC6.7030308@sieb.net> <20080722102457.GA773@elte.hu> <200807221251.10843.jbe@pengutronix.de> <4886DB31.8070306@sieb.net> <20080728153224.GA28495@elte.hu>
In-Reply-To: <20080728153224.GA28495@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Samuel Sieb <samuel@sieb.net> wrote:
> 
>>> The only critical tweak I found is the one that changes the 
>>> "Performance Control Incrementer" because its settings depends on the 
>>> CPU's core frequency. Maybe this tweak should be removed, because the 
>>> BIOS (hopefully) set it in a way the hardware supports.
>> This was the only line that was a problem.  See the other branch of 
>> this thread with Juergen Beisert.
> 
> any patch we should pick up to make your box boot?
> 
Are you suggesting I should make the patch or you're just asking which 
lines?  What I did to make a kernel that boots was to comment out the 
line that calls the incrementor setup function.  It sounds like the 
stepping 2 version doesn't have the problem, so if possible could you 
call the function based on it not being a stepping 1 CPU?
