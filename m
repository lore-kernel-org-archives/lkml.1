Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbYEHA1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbYEHA1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYEHA1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:27:40 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:39699 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbYEHA1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:27:39 -0400
Message-ID: <48224930.9030901@keyaccess.nl>
Date: Thu, 08 May 2008 02:28:32 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-05-08 02:19, Linus Torvalds wrote:
> 
> On Thu, 8 May 2008, Rene Herman wrote:
>> And again, the kernel DOES see that my CPU features PAT, it just refuses
>> to use it.
> 
> Umm, and this is different how from clearing the PSE bit when we decide 
> not to use large-page support? 

It's not. That one's bad also. It's just that this one is the first one I
notice due to them blasted people screwing over my lowly Duron.

I completely and fully agree with your new flag suggestion. Was just in a
git bisect and am actually on the lowly thing in question so I'm not fast
but was looking already. X86_FEATURE_PAT_GOOD. Is it safe to reuse bit 14
now?

Rene.


