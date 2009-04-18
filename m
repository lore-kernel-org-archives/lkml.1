Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbZDRTd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbZDRTd4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 15:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbZDRTds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 15:33:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753947AbZDRTdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 15:33:47 -0400
Date: Sat, 18 Apr 2009 12:28:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Russell King <rmk+lkml@arm.linux.org.uk>, takata@linux-m32r.org,
       Christoph Hellwig <hch@lst.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: use include/gen for mach-types.h
In-Reply-To: <20090418181714.GA25786@uranus.ravnborg.org>
Message-ID: <alpine.LFD.2.00.0904181226170.4042@localhost.localdomain>
References: <20090416150707.GA941@lst.de> <20090416164050.GB4850@uranus.ravnborg.org> <swfmyag9fx8.wl%takata.hirokazu@renesas.com> <alpine.LFD.2.00.0904171034140.4042@localhost.localdomain> <20090417221440.GA16791@uranus.ravnborg.org>
 <20090418101444.GA9768@flint.arm.linux.org.uk> <20090418181714.GA25786@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Apr 2009, Sam Ravnborg wrote:
>
> diff --git a/include/gen/.gitignore b/include/gen/.gitignore
> new file mode 100644
> index 0000000..1e809fd
> --- /dev/null
> +++ b/include/gen/.gitignore
> @@ -0,0 +1,2 @@
> +# mach-types.h is used by arm
> +mach-types.h

I think this is bad.

The whole point of having 'include/gen' should be that _all_ files in that 
directory should be generated. So it should be include/.gitignore that 
just contains the pattern "gen/" and that's it.

That said, I also dislike "gen" as a name. To me, it is more likely to 
mean "generation" in the sense of father/son/grandson than "generated". 
Why not spell it out?

		Linus
