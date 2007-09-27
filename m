Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbXI0IZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbXI0IZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 04:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbXI0IYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 04:24:53 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54668 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbXI0IYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 04:24:52 -0400
Date: Thu, 27 Sep 2007 10:26:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Henry Nestler <Henry.Ne@Arcor.de>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: kbuild: LDFLAGS_MODULE unusable for external module builds (2.6.23-rc2)
Message-ID: <20070927082620.GA29452@uranus.ravnborg.org>
References: <46F8D9B8.3090806@Arcor.de> <20070925192250.GA14689@uranus.ravnborg.org> <46FA2CC0.2000204@Arcor.de> <20070926110130.GA20950@uranus.ravnborg.org> <46FA4313.1060201@Arcor.de> <46FB6820.2090708@Arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FB6820.2090708@Arcor.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henry.

Snipped a very detaild an good example...

Thanks for your comprehensive feedback on this topic.
> 
> Idea for future:
> An 'APPEND_LDFLAGS' would be nice to append flags behind the last .o
> object. Than can be close the group with --end-group.
> 
> Exactly linker call would be with grouping only archives, and the group
> block behind the last object, for example:
> ld -m elf_i386 -r -o module.o file1.o --start-group A/lib.a B/lib.a
> --end-group
> 
> But remember: We can very good live with EXTRA_LDFLAGS, it's usable in
> all 2.6 kernels.

As there is no dire need for it now I will not add EXTRA_APPEND_LDFLAGS.
But I will keep your suggestion in mind should it be useful to solve the
hackish use in the vdso Makefile's.

Thanks for your feedback and do not hesistate to ask if you run into
additional troubles in the future.

	Sam
