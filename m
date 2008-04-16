Return-Path: <linux-kernel-owner+w=401wt.eu-S1765293AbYDPTWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765293AbYDPTWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYDPTWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:22:37 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38855 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYDPTWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:22:36 -0400
Date: Wed, 16 Apr 2008 21:23:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 and DEBUG_SECTION_MISMATCH
Message-ID: <20080416192306.GA3090@uranus.ravnborg.org>
References: <20080416175135.GN1677@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416175135.GN1677@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian.

On Wed, Apr 16, 2008 at 08:51:35PM +0300, Adrian Bunk wrote:
> Hi Sam,
> 
> although DEBUG_SECTION_MISMATCH allows to also find exotig things like 
> finding bugs only present when using gcc < 3.4 and CONFIG_HOTPLUG=n at 
> the same time, the problem is that we print
>     WARNING: modpost: Found 13 section mismatch(es).
>     To see full details build your kernel with:
>     'make CONFIG_DEBUG_SECTION_MISMATCH=y'

So we print exact instructions how to get more info.
And several people has posted list of section mismatch warnings recently,
so the instructions are understood.
I fail to see any problem with that.

Obviously it would be better if we bailed out with a big fat warning
if someone _adds_ a new section mismatch warning.

> but CONFIG_DEBUG_SECTION_MISMATCH is not offered in 2.6.25.
If you by "not offered" try to say that the CONFIG option
is not available in kconfig then you are correct.
But you are in the instructions above asked to supply it
on the command line to make - not to enable it in the
kconfig configuration.

I would prefer we were down to less than 5 warnings so we could
enable it in kconfig but maybe after next merge window.

	Sam
