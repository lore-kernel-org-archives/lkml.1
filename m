Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbYEHAUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbYEHAUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYEHAUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:20:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbYEHAUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:20:19 -0400
Date: Wed, 7 May 2008 17:19:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
In-Reply-To: <48224507.8010102@keyaccess.nl>
Message-ID: <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl>
 <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Rene Herman wrote:
> 
> And again, the kernel DOES see that my CPU features PAT, it just refuses
> to use it.

Umm, and this is different how from clearing the PSE bit when we decide 
not to use large-page support? 

See arch/x86/kernel/setup_32.c: parse_mem() for an example.

Rene - you have valid points (ie that patches were NAK'ed etc and you 
might have wanted better changelog entries), but trust me, this one is not 
one of them. /proc/cpuinfo and the kernel clearing feature bits is 
_normal_. It's how it has always been.

			Linus
