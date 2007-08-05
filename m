Return-Path: <linux-kernel-owner+w=401wt.eu-S1761969AbXHEUMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbXHEUMB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbXHEULv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:11:51 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51918 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757483AbXHEULu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:11:50 -0400
X-Sasl-enc: ooh3NTY6EpCIK4wybJNaTUTHdyK9GbYcUx4uTtPgGYWb 1186344709
Date: Sun, 5 Aug 2007 17:11:46 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: ibm-acpi@hmh.eng.br, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: suspend/hibernation regression between 2.6.19 and 2.6.20 w/
	Thinkpad T41
Message-ID: <20070805201146.GA16723@khazad-dum.debian.net>
References: <200708051902.18801.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708051902.18801.toralf.foerster@gmx.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Aug 2007, Toralf Förster wrote:
> It is a small - but IMHO nagging - regression between these 2 kernel versions.
> 
> To make a "software suspend" at this notebook ("suspend to RAM") you have
> to press <Fn>+ <F4>. Pressing the <Fn>-Key after that wakes up the notenbook.
> 
> If you hibernated the system ("suspend to disc"), you have to press the power
> button to wake up the notebook.
> 
> But now there is an issue if you want to wake up this notebook, after it was
> suspended with <Fn>+<F4> again. It is now not possible to wake it up with <Fn>,
> instead you have to press the power button as you would have it to do after a
> hibernation.
> 
> This issue occures in the current 2.6.21 kernel too.
> (all tested at a stable Gentoo system - also with git-kernel-versions).

I am at a loss of how thinkpad-acpi could in any way cause, or change, the
firmware wake-up notification behaviour.

That said, my T43 with 2.6.21 and latest-of-the-latest thinkpad-acpi wakes
up from S3 just fine by pressing the "Fn" key and holding it down for ~2s.
I didn't know it did that :-)  I always use the power button.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
