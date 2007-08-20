Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbXHTVdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbXHTVdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbXHTVdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:33:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXHTVdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:33:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
X-Fcc: ~/Mail/linus
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [POWERPC] Fix for assembler -g
In-Reply-To: Segher Boessenkool's message of  Monday, 20 August 2007 23:28:33 +0200 <7666a3cee89296540b8ade4bedc1e52e@kernel.crashing.org>
X-Windows: it could be worse, but it'll take time.
Message-Id: <20070820213259.956EB4D05F4@magilla.localdomain>
Date: Mon, 20 Aug 2007 14:32:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But there is no lparmap.o!  lparmap.s is the generated file.

Yeah, tell that to scripts/Makefile.lib:

	_c_flags       = $(CFLAGS) $(EXTRA_CFLAGS) $(CFLAGS_$(basetarget).o)

What would do what a person expects is $(CFLAGS_$(@F)), I think.

> Maybe the best fix is
> 
> 	$(obj)/lparmap.s: CFLAGS += -g0

Whatever works, I don't care.


Thanks,
Roland
