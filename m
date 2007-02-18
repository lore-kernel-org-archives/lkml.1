Return-Path: <linux-kernel-owner+w=401wt.eu-S1161193AbXBRJAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161193AbXBRJAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 04:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161194AbXBRJAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 04:00:51 -0500
Received: from main.gmane.org ([80.91.229.2]:50614 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161193AbXBRJAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 04:00:50 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: Re: GPL vs non-GPL device drivers
Date: Sun, 18 Feb 2007 10:00:27 +0100
Message-ID: <er94jf$s8s$1@sea.gmane.org>
References: <er6mdq$ti8$1@sea.gmane.org> <MDEHLPKNGKAHNMBLJOLKKEKKBKAC.davids@webmaster.com> <er837a$8ks$1@sea.gmane.org> <f2b55d220702171555k1fde2e0ah2f46d5c2c1016a1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: host-84-221-16-91.cust-adsl.tiscali.it
User-Agent: KNode/0.10.4
X-Face: ::w9}R^l{WGM\{y)C0QF@4^U,',W3Mk^X0HP)=:bKM^Z]A9+6bY6fe3}O*]fH{l<j1/9RTp  `KR0idy]Im#9^%}P5Dga'>AViT_'?&>&ufo2_X5Vs3C^tPO@drZRuu&6iK}x}~9`F\-dNZ>(p|V7`4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 February 2007 00:55, Michael K. Edwards wrote:

> Or they could run:
>     find . -type f -exec
perl -i.bak -pe 's/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/g'
> and be done with it.  Or even just MODULE_LICENSE("GPL") in their
> module -- that's not "lying about the module license", it's "doing the
> minimum necessary in order to interoperate efficiently with the
> kernel".  Atari v. Nintendo is still good law, but only to the
> extent that it does not conflict with Lexmark, which now has the seal
> of Supreme Court approval.  And (IMHO, IANAL) if writing
> MODULE_LICENSE("GPL") is obviously the only remotely efficient way to
> achieve the goal of interoperation with the kernels that people
> already have on their systems

Except that this is not about a driver that is supposed to interoperated
with the kernels people already have on their systems. This is about
shipping new (embedded) systems with a modified (if you go the s/_GPL//g
route, even more so) Linux kernel, and distribution a modified kernel *has*
to comply with the GPL, since this is *exactly* what the GPL is about:
redistribution of modified copies of the work.

-- 
Giuseppe "Oblomov" Bilotta

