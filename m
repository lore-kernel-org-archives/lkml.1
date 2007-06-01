Return-Path: <linux-kernel-owner+w=401wt.eu-S1761893AbXFAMWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761893AbXFAMWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 08:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761111AbXFAMWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 08:22:32 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:5664 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761232AbXFAMWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 08:22:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=dFbTGfOpRbFYWWG6i/9l1QwqKs4WW5sJWZWIt69PSc6CoJZ+cLsGTIPeqQPILnhdwkxL9drBXJ5pwzwTaud82g9qo6ImEQvAhbayM39GUIV9vFncQ/cH22vh4sBbjgknrPT2CLCpVektj4QS9iVUigQD4yIwpHcxAlG91cmOwnk=
Message-ID: <46600F6B.3060601@googlemail.com>
Date: Fri, 01 Jun 2007 14:22:03 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tero Roponen <teanropo@jyu.fi>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Antonino A. Daplas" <adaplas@gmail.com>, zach@vmware.com,
       =?ISO-8859-2?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <ak@suse.de>,
       discuss@x86-64.org, Jeff Garzik <jeff@garzik.org>,
       Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [3/3] 2.6.22-rc3: known regressions with patches v2
References: <46600D36.7060405@googlemail.com>
In-Reply-To: <46600D36.7060405@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc3
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



TTY

Subject    : signal: multithread program returns with wrong errno on receiving SIGSTOP
References : http://lkml.org/lkml/2007/5/27/189
Submitter  : Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Handled-By : Oleg Nesterov <oleg@tv-sign.ru>
Patch      : http://lkml.org/lkml/2007/5/28/27
Status     : patch available

Subject    : tty-related oops in latest kernel(s)
References : http://lkml.org/lkml/2007/5/27/104
Submitter  : Tero Roponen <teanropo@jyu.fi>
Handled-By : Antonino A. Daplas <adaplas@gmail.com>
Patch      : http://lkml.org/lkml/2007/5/31/35
Status     : patch available



Virtualization

Subject    : build failed in arch/i386/kernel/vmi.c
References : http://lkml.org/lkml/2007/5/24/119
Submitter  : Toralf Förster <toralf.foerster@gmx.de>
Handled-By : Alexey Dobriyan <adobriyan@gmail.com>
Patch      : http://lkml.org/lkml/2007/5/24/143
Status     : patch available



x86-64

Subject    : BUG: at mm/slab.c:777 __find_general_cachep()
References : http://lkml.org/lkml/2007/5/18/17
Submitter  : Jeff Garzik <jeff@garzik.org>
Handled-By : Ben Collins <ben.collins@ubuntu.com>
Patch      : http://lkml.org/lkml/2007/5/18/19
Status     : patch available



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"

