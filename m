Return-Path: <linux-kernel-owner+w=401wt.eu-S933300AbZGPUXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbZGPUXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933284AbZGPUXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:23:02 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59300 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbZGPUXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:23:01 -0400
Date: Thu, 16 Jul 2009 22:23:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexey Fisher <bug-track@fisher-privat.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Subject: Re: [PATCH] x86: _edata should include all .data.* sections on
	X86_64
Message-ID: <20090716202300.GA6096@merkur.ravnborg.org>
Mail-Followup-To: Catalin Marinas <catalin.marinas@arm.com>,
	Alexey Fisher <bug-track@fisher-privat.net>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, x86@kernel.org
References: <4A5C20E5.6010203@fisher-privat.net> <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com> <4A5C41C8.7040904@fisher-privat.net> <1247564356.28240.30.camel@pc1117.cambridge.arm.com> <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 10:52:55AM +0100, Catalin Marinas wrote:
> The .data.read_mostly and .data.cacheline_aligned sections aren't
> covered by the _sdata .. _edata range on X86_64. This affects the
> kmemleak reporting leading to possible false positives by not scanning
> all the whole data section.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---

To do so was on my todo list when I looked at vmlinux.lds.S for x86, but
as I got sidetracked I never got to it. Which I see was bad..
This patch has my:

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
