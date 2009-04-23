Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZDWGg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZDWGg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZDWGgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:36:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbZDWGgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:36:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: remove PT_DTRACE from arch/* except arch/um
In-Reply-To: Oleg Nesterov's message of  Thursday, 23 April 2009 00:06:49 +0200 <20090422220649.GB22755@redhat.com>
References: <20090330185146.D525AFC3AB@magilla.sf.frob.com>
	<20090408203954.GA26816@redhat.com>
	<20090416204004.GA28013@redhat.com>
	<20090416232430.4DAE4FC3C6@magilla.sf.frob.com>
	<20090420183718.GC32527@redhat.com>
	<20090421011354.4B19EFC3C7@magilla.sf.frob.com>
	<20090421214819.GA22845@redhat.com>
	<20090422032205.B8D39FC3C7@magilla.sf.frob.com>
	<20090422220400.GA22755@redhat.com>
	<20090422220649.GB22755@redhat.com>
X-Zippy-Says: BEEP-BEEP!!  I'm a '49 STUDEBAKER!!
Message-Id: <20090423063613.278E8FC3C7@magilla.sf.frob.com>
Date: Wed, 22 Apr 2009 23:36:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unfortunately, I know nothing about these arches, so I can only rely on grep.
> But it really looks like nobody except arch/um actually uses DTRACE.

Same with me.  But I do trust grep, and my knowledge that PT_DTRACE was
widely used old cruft.  To be really paranoid, you can grep (painfully)
for all ->ptrace ('[>.]ptrace\>') in arch code, plus find any that use
it in asm-offsets.c, and then grep for TSK_PTRACE or whatever macro is
defined there.  (Chances are high that there are no uses that you missed.)
Or you could just leave it to the arch people to pipe up if we're wrong.

The patches all look quite right and harmless to me.


Thanks,
Roland
