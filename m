Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbZJaKAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbZJaKAA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 06:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbZJaKAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 06:00:00 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:38916 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974AbZJaJ77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:59:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gzfywAtmmzyLtseqJQZHZ82yeuXk9z3lyrJ+zhMfbAti9T/3Vrh6+ZMXaTIEq0ggOe
         0n0bX6V7jF9nbHcV79q8/uUQ0yFlqaFdoTb0h0NtddEhJZA7mSI5HvqFl8YksSrpOcVf
         u8OK8I9s55eS89vKCBG4jvA0RwL5+PdIvRzMA=
Date: Sat, 31 Oct 2009 12:59:59 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86, apicdef: Fix checkpatch issues in apicdef.h
Message-ID: <20091031095959.GC4869@lenovo>
References: <b9df5fa10910310229s2d9f85c1y31403ecbf8c31567@mail.gmail.com> <20091031094431.GB4869@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091031094431.GB4869@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sat, Oct 31, 2009 at 12:44:31PM +0300]
| [Rakib Mullick - Sat, Oct 31, 2009 at 03:29:32PM +0600]
| |
| |  In apicdef.h - we have a checkpatch issue - needs to be fixed.
| | We were warned by the following checkpatch warning:
| | 
| | ERROR: space prohibited before that ':' (ctx:WxW)
| | #276: FILE: arch/x86/include/asm/apicdef.h:376:
| | +                       hi      : 1;
| |                                 ^
| | ---
| | Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
| | 
| 
| Hi Rakib,
| 
| personally I would not change it even having checkpatch
| issue. Really, it's easier to read this bitfield width
| aligned rather then moved left. But this is a personal
| opinion only (sorry).
| 
| 	-- Cyrill

On the other hands -- I wonder if we need this structure
at all. Perhaps there was an idea to use it with suspend/resume
actions? Ingo, Maciej, Yinghai?

	-- Cyrill
