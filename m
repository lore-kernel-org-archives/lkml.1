Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbXKEI1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbXKEI1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 03:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbXKEI1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 03:27:21 -0500
Received: from adicia.telenet-ops.be ([195.130.132.56]:44274 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbXKEI1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 03:27:20 -0500
Date: Mon, 5 Nov 2007 09:27:16 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: duplicated include files
In-Reply-To: <Pine.LNX.4.64.0711041229580.27153@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0711050924420.6173@anakin>
References: <Pine.LNX.4.64.0711041229580.27153@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2007, Robert P. J. Day wrote:
>   given the recent patches to remove duplicated #include preprocessor
> directives in source files, let it be known that there are a number of
> them:
> 
>   http://www.crashcourse.ca/wiki/index.php/Duplicate_include_files
> 
> help yourself.

Thanks!

drivers/scsi/gvp11.c is a false positive, as it includes "gvp11.h" once
without HOSTS_C defined and once with.

drivers/scsi/mvme147.c looks similar, but "mvme147.h" does not check for
HOSTS_C (anymore?).

But both need a cleanup anyway...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
