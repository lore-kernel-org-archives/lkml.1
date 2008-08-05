Return-Path: <linux-kernel-owner+w=401wt.eu-S1759854AbYHECxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbYHECxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 22:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760165AbYHECxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 22:53:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbYHECxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 22:53:03 -0400
Message-ID: <4897BD23.8060801@zytor.com>
Date: Mon, 04 Aug 2008 19:38:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>	<m1iqukwjjg.fsf@frodo.ebiederm.org>	<86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>	<m1wsj0nyx6.fsf@frodo.ebiederm.org>	<86802c440808011809t275aa511h4a1e9d70ede21702@mail.gmail.com> <m163qkjirc.fsf@frodo.ebiederm.org> <4896FCD0.8050006@sgi.com>
In-Reply-To: <4896FCD0.8050006@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
>>
>> So on my wish list is to stably encode the MSI interurrpt numbers.  And
>> using a sparse irq address space I can.  As it only takes 28 bits to hold
>> the complete bus + device + function + msi source [ 0-4095 ] 
> 
> Don't you need "domain" (node) in the bus:device:function:vector combination?
> (Or [hack] use a lot bigger field for bus with the node encoded into it.)
> 

You definitely need domain, and that blows the 32-bit limit quite out of 
the water.

	-hpa
