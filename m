Return-Path: <linux-kernel-owner+w=401wt.eu-S1762361AbXGFBup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762361AbXGFBup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 21:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759666AbXGFBug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 21:50:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:56123 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759597AbXGFBug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 21:50:36 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: slow down printk during boot.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>
Reply-To: 7eggert@gmx.de
Date: Fri, 06 Jul 2007 03:50:11 +0200
References: <8DGUc-ER-37@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1I6cxX-0007Dj-Lo@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+dmgco6Fh7zcBfivvByuqp983pyJQahfoaA/X
 exT6Lg+ZqjK8gu9PcqI0xfeCmIaSDBEiurnQYPAh8IpQl5V++P
 75kZK3WbPLyGrycqquvpw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> wrote:

> This patch from Randy has proven quite useful from time to time,
> and has been in Fedora kernels for a while for that reason.
> I fixed up some checkpatch warnings, and rediffed it a bunch
> of times, Randy did the heavy lifting.
> 
> ---
> 
> This one delays each printk() during boot by a variable time
> (from kernel command line), while system_state == SYSTEM_BOOTING.
> Caveat:  it's not terribly SMP safe or SMP nice.
> Any ideas for improvements (esp. in the SMP area) are appreciated.

I just created a different patch, which replaces the panic with one that
does allow scrolling and reading the messages. Maybe that would be the
better approach ...

The patch was sent in:
Subject: [RFC][PATCH] introduce panic_gently
Message-ID: Pine.LNX.4.58.0707060034330.18989@be1.lrz
news:8DICF-3CV-47@gated-at.bofh.it
-- 
Justify my text? I'm sorry but it has no excuse. 

Friﬂ, Spammer: ij@drZsf.7eggert.dyndns.org 6.h@lFus97h.7eggert.dyndns.org
 9yTtaaH5@sLxhc.7eggert.dyndns.org dy3pwcw@rfhqOp7i.7eggert.dyndns.org
