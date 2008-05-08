Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbYEHMjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbYEHMjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 08:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbYEHMjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 08:39:37 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:46809 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbYEHMjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 08:39:36 -0400
Message-ID: <4822F4A1.2030602@keyaccess.nl>
Date: Thu, 08 May 2008 14:40:01 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: introduce a new Linux defined feature flag for PAT
 support
References: <48210A71.1060409@keyaccess.nl>	<86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>	<20080507124650.GD29935@cs181133002.pp.htv.fi>	<alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>	<48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com>	<48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com>	<48224507.8010102@keyaccess.nl>	<alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org>	<48224930.9030901@keyaccess.nl> <48225DEC.2030502@keyaccess.nl> <878wylayiw.fsf@basil.nowhere.org>
In-Reply-To: <878wylayiw.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-05-08 12:19, Andi Kleen wrote:

>> Use a new Linux defined X86_FEATURE_PAT_GOOD feature flag to
> 
> Better would be PAT_TESTED or PAT_RANDOMLY_APPROVED. Most of these
> CPUs without PAT_GOOD have actually perfectly good PAT, as Windows
> proves every day.
> 
> The main flaw in all of this of course is that there is no procedure
> to test CPUs which do not have the flag set yet.

Quite. And hiding the fact that the CPU _should_ have perfectly good
PAT doesn't help any at all. The discussion turned into a mini-flame
war enough that now noone would even consider backing down, but this
current PAT setup just sucks plain and simple.

Rene.
