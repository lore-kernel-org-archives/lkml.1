Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbZLIThT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbZLIThT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbZLIThQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:37:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34584 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367AbZLIThP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:37:15 -0500
Message-ID: <4B1FFBE8.2000302@zytor.com>
Date: Wed, 09 Dec 2009 11:35:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
References: <20091203210913.GA24351@elte.hu>	 <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain>	 <20091209073632.GD8187@elte.hu> <4B1FED0D.7060003@goop.org>	 <alpine.LFD.2.00.0912091039050.3560@localhost.localdomain>	 <4B1FF27E.8030701@zytor.com> <73c1f2160912091125s166219ddl56e7cbede800ac3@mail.gmail.com>
In-Reply-To: <73c1f2160912091125s166219ddl56e7cbede800ac3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2009 11:25 AM, Brian Gerst wrote:
> 
> I had started working on a patchset like this when this issue came up
> the first time.  I'll get it up to date and send it out.  It would be
> nice if this could be done for all syscalls, so that
> asmlinkage_protect() isn't needed.
> 

asmlinkage_protect() is evil in the extreme and really should be killed.

In fact, I started working on a patchset to eliminate asmlinkage completely.

	-hpa
