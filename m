Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbZELQQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbZELQQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbZELQQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:16:46 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:8605 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbZELQQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:16:45 -0400
Message-Id: <4A09BD0E020000780000081C@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 12 May 2009 17:16:46 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Nick Piggin" <npiggin@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: uses of cmpxchg/xadd in spinlock.h and rwsem.h vs.
	 CONFIG_M386
References: <4A09AF8402000078000007DC@vpn.id2.novell.com>
 <4A099AF0.8020001@zytor.com> <20090512155702.GB31131@wotan.suse.de>
 <4A099DFC.7040905@zytor.com>
In-Reply-To: <4A099DFC.7040905@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin" <hpa@zytor.com> 12.05.09 18:04 >>>
>Nick Piggin wrote:
>> 
>> Is it time to get rid of attempts to support SMP kernels that run on 386, then?
>> Considering we don't actually support SMP 386, and if there is any 386 systems
>> then they're going to be running custom kernels anyway.
>> 
>
>Makes sense to me.  We have never supported SMP 386 to the best of my
>knowledge, and a patch to rip that out would be appreciated.

But why shouldn't a distro be allowed to configure a kernel that runs (UP) on
i386 and also MP on modern systems?

Jan

