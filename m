Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbYLTNTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbYLTNTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 08:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYLTNTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 08:19:49 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:39136 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYLTNTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 08:19:48 -0500
Date: Sat, 20 Dec 2008 14:19:46 +0100
From: Andreas Mohr <andi@lisas.de>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Andreas Mohr <andi@lisas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [patch] Re: [Bug #12100] resume (S2R) broken by Intel
	microcode module, on A110L
Message-ID: <20081220131946.GA31366@rhlx01.hs-esslingen.de>
References: <1229728524.5122.13.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229728524.5122.13.camel@earth>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Dec 20, 2008 at 12:15:24AM +0100, Dmitry Adamushko wrote:
> I'd appreciate if someone with an appropriate system might give a try to the
> 2nd patch (titled "fix a comparison && deadlock...").
> 
> 
> In any case, the deadlock situation is a must-have fix.

YES, that actually fixed it!!

Built -rc9, booted 3 times and suspended, always deadlock upon resume.
Patched -rc9, make modules_install, suspended 3 times, always fine.

Weird, I thought I had attempted all (most?) of the parts that your patch
references before...

Thanks a lot for your very responsive handling!

I suppose this can get to -urgent now, JIT for the Christmas
release?

Andreas Mohr
