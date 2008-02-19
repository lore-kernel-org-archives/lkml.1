Return-Path: <linux-kernel-owner+w=401wt.eu-S1751589AbYBSIh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbYBSIh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYBSIhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:37:11 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:39235 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYBSIhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:37:09 -0500
Date: Tue, 19 Feb 2008 09:37:05 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Buesch <mb@bu3sch.de>
cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Gordon Farquharson <gordonfarquharson@gmail.com>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
In-Reply-To: <200802190004.47594.mb@bu3sch.de>
Message-ID: <Pine.LNX.4.64.0802190935450.25052@anakin>
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com>
 <200802182343.12749.mb@bu3sch.de> <20080218225354.GE23181@flint.arm.linux.org.uk>
 <200802190004.47594.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Michael Buesch wrote:
> Still I can't see why this structure will cause alignment issues, as the
> compiler will pad it up to the right boundary automagically, as you said
> above. Why doesn't the ARM compiler do this?

The ARM compiler handles it correctly.

But the ugly hacks to get useful information about the module device
table using the _host_ compiler fail.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
