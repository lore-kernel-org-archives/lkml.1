Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbXHVHHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbXHVHHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 03:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXHVHG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 03:06:57 -0400
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:53209 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbXHVHG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 03:06:56 -0400
Date: Wed, 22 Aug 2007 09:06:54 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG?] 2.6.23-rc3 on alpha
In-Reply-To: <20070822013618.BE293DBA2@gherkin.frus.com>
Message-ID: <Pine.LNX.4.64.0708220906080.9716@anakin>
References: <20070822013618.BE293DBA2@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Bob Tracy wrote:
> I'm seeing something new and strange with 2.6.23-rc3 that I wasn't
> seeing in the 2.6.22+ kernels.  I've got the bootlogo code enabled,
> and at the point during system initialization where the logo
> disappears, the console switches from tty1 to tty2.  I can switch
> back to tty1, so other than the unexpected console tty switch, there
> doesn't seem to be anything "unfortunate" happening.
> 
> Any ideas/explanations?  It's completely repeatable.  I don't think
> it's related to the "aboot" patches :-).

The kernel doesn't make the logo disappear, the boot scripts (in
userspace) do that. So I guess they also switch the console from tty1 to
tty2.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
