Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbXI2CuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbXI2CuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 22:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbXI2CuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 22:50:13 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44501 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbXI2CuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 22:50:11 -0400
X-Greylist: delayed 1791 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 22:50:11 EDT
X-Sasl-enc: rHE5REHGZaJQgeYHUhhxj+34T/I/nLKPtEjeP6qrGoWN 1191032419
Date: Fri, 28 Sep 2007 23:20:13 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8,
	v2.6.22.8, v2.6.21.7, v2.6.20.20
Message-ID: <20070929022013.GA24496@khazad-dum.debian.net>
References: <20070926111357.GA10655@elte.hu> <20070928222631.25504d68@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070928222631.25504d68@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007, Alejandro Riveira Fernández wrote:
>  I feel it better than 20.5 but the later is more stable. Let me explain.
> 
>  I patched a 2.6.22.9 kernel with both versions 22 and 20.5[1]. With the 22
>  version if i lock the screen (run screensaver) or i try to run a wine program
>  i experience a hard lock up no keyboard or mouse and i have to reboot the
>  machine (i can not try to access it via ssh because i do not have a second
>  machine).

I have seen that twice with v20.5 under 2.6.22.7/.8. Didn't see it yet with
v22.  xterm would get pissed if I tried to "secure keyboard", so something
stole the keyboard focus and wouldn't give it back to xorg.  Maybe a locking
bug in xorg somewhere?

Anyway, my kernel is NOT tainted, so rest assured that at least this one is
not nVidia's fault.

BTW, v20.5 in 2.6.21.7 would sometimes cause dmcrypt to oops when first
mounting a LUKS volume if there was some non-extra-light disk activity going
on.  Probably something missing in the backport to 2.6.21...

Sorry, days down here have been very busy, so I didn't have time to send a
proper bug report.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
