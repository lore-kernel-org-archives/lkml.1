Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbZBUNHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbZBUNHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 08:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZBUNHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 08:07:46 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:37806 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZBUNHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 08:07:46 -0500
Date: Sat, 21 Feb 2009 14:09:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-ID: <20090221130937.GA31562@uranus.ravnborg.org>
References: <20081129180144.GA15533@uranus.ravnborg.org> <20081130171604.dc3c8715.h.mitake@gmail.com> <20081130083700.GA31644@elte.hu> <20081130092407.GA10802@elte.hu> <20081201002056.d9f9204c.h.mitake@gmail.com> <20081130161504.GA25627@elte.hu> <a6b9f31a0812010551h28c0841fxa2a26af4645df64@mail.gmail.com> <20081201135922.GA30068@elte.hu> <a6b9f31a0812011558o373edbd3r9690efe539d43ca0@mail.gmail.com> <20090221191101.62945118.h.mitake@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090221191101.62945118.h.mitake@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> Very sorry for long distance between my previous post and this...
> 
> I wrote a patch to add HAVE_READQ and HAVE_WRITEQ to each architecture's Kconfig file
> which have readq() and writeq().
> 
> But there is problem.
> I wrote helps for HAVE_READQ and HAVE_WRITEQ in Kconfig file
> accodring to the advice by Russell King ( http://marc.info/?l=linux-kernel&m=122701161824218&w=2 ),
> but these helps are invisible when I doing menuconfig.
> (when type '/' and search readq string, HAVE_READQ found, but
> help string is not printed...)
> 
> Do you have some nice technique that make these helps visible easily?

The options are not visible in menuconfig and therefore the is not
much point in displaying help for them thre when you search for the symbol.
But the help contained in the KConfig file is fully justified as it is
now documented why/when to select these options.

	Sam
