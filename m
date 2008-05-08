Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbYEHQwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbYEHQwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763286AbYEHQwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:52:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134AbYEHQwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:52:39 -0400
Message-ID: <48232F86.7050308@zytor.com>
Date: Thu, 08 May 2008 09:51:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andi Kleen <andi@firstfloor.org>, Rene Herman <rene.herman@keyaccess.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: introduce a new Linux defined feature flag for PAT
 support
References: <48210A71.1060409@keyaccess.nl>	<86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>	<20080507124650.GD29935@cs181133002.pp.htv.fi>	<alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>	<48221AE3.6020602@keyaccess.nl>	<482233F0.7040000@zytor.com>	<48224318.8020209@keyaccess.nl>	<48224361.5080102@zytor.com>	<48224507.8010102@keyaccess.nl>	<alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org>	<48224930.9030901@keyaccess.nl>	<48225DEC.2030502@keyaccess.nl>	<878wylayiw.fsf@basil.nowhere.org>	<4822F4A1.2030602@keyaccess.nl>	<482302A3.3010405@firstfloor.org> <20080508163250.4c7692c6@core>
In-Reply-To: <20080508163250.4c7692c6@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> For old CPUs it is actually ok (after all they worked for years without
>> PAT), I just don't like it for new CPUs. It's a bad idea there and
>> in the x86 world it is a reasonable expectation that CPU features
>> generally work.
> 
> Agreed 100%. We should default to assuming newer processors work. That
> will be true in almost if not all cases anyway, and since it'll bite
> anyone at Intel/AMD/.. testing new CPU steppings when it is on by default
> any problem cases won't be leaving the labs.

Yes, capping the upper end is an actively bad thing, because it can 
actually *make* bugs appear (by artifically limiting testing by CPU houses.)

	-hpa

