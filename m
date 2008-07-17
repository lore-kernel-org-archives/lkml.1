Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbYGQSvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbYGQSvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758239AbYGQSuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:50:40 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:37960 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890AbYGQSui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:50:38 -0400
X-Greylist: delayed 101107 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2008 14:50:38 EDT
Date: Thu, 17 Jul 2008 20:50:35 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [Linux-fbdev-devel] [PATCH] [RESEND] fbcon: simple text blinking
 implementation
In-Reply-To: <487F4E20.6090802@eu.citrix.com>
Message-ID: <Pine.LNX.4.64.0807172047340.20605@anakin>
References: <487F4E20.6090802@eu.citrix.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Stefano Stabellini wrote:
> at the moment blinking is not supported in fbcon but it is supported in
> vgacon.
> Since userspace applications don't distinguish between the two, they just
> assume that the linux terminal is always capable of blinking text.
> However implementing blinking in fbcon is not so difficult: this patch
> provides a very simple (too simple?) implementation of that.
> I am using the flashcursor function to scan the buffer for blinking text.
> For the sake of efficiency I added a simple flag mechanism to disable the scan
> when I am sure that there are no blinking characters on the screen.

Ehrm, there's already blinking support on some platforms?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
