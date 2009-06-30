Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZF3Oie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZF3Oie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZF3Oi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:38:26 -0400
Received: from fmailhost03.isp.att.net ([207.115.11.53]:46520 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbZF3OiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:38:25 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A4A2369.60409@lwfinger.net>
Date: Tue, 30 Jun 2009 09:38:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: David Rientjes <rientjes@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>	 <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net>	 <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com>	 <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com>	 <alpine.DEB.2.00.0906300032310.11018@chino.kir.corp.google.com> <84144f020906300124n24e206b5tc85dd5cc4661bde7@mail.gmail.com>
In-Reply-To: <84144f020906300124n24e206b5tc85dd5cc4661bde7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> 
> Yup, I was referring to slub_debug=A and no, I don't agree with you
> that it should be on by default. Only people who know what they're
> doing should enable the option and a random tester by definition
> doesn't (no offence to Mr. Random Tester).

None taken.

For me, the next step is clear. As I'm much more interested in finding
bugs in the wireless system than in the mechanics of SLUB allocation,
I need to disable CONFIG_SLUB_DEBUG_ON. BTW, I use SLAB on Linus's
mainline tree and SLUB on the wireless testing tree. I build and boot
the mainline kernels mostly to look for quick failures/regressions,
but run the w-t kernels looking for longer-term effects such as memory
fragmentation or slow memory leaks.

For Rafael's benefit, we do need to decide if this is a bug or merely
an unintended side effect. My sense is the latter and Bug #13319
should have a summary of this discussion added to the record, and then
the bug should be closed.

Larry

