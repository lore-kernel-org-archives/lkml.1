Return-Path: <linux-kernel-owner+w=401wt.eu-S1030397AbXBOR76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030397AbXBOR76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030398AbXBOR76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:59:58 -0500
Received: from v813.rev.tld.pl ([195.149.226.213]:52264 "EHLO
	smtp.host4.kei.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030397AbXBOR75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:59:57 -0500
X-clamdmail: clamdmail 0.18a
From: Marcin Juszkiewicz <openembedded@hrw.one.pl>
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.20-mm1
Date: Thu, 15 Feb 2007 19:00:16 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org> <200702151733.l1FHXatF025688@turing-police.cc.vt.edu>
In-Reply-To: <200702151733.l1FHXatF025688@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702151900.18270.openembedded@hrw.one.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia czwartek, 15 lutego 2007, Valdis.Kletnieks@vt.edu napisa³:
> On Thu, 15 Feb 2007 05:14:08 PST, Andrew Morton said:

> git-backlight.patch contains this:
>
> +config BACKLIGHT_PROGEAR
> +       tristate "Frontpath ProGear Backlight Driver"
> +       depends on BACKLIGHT_CLASS_DEVICE && PCI && X86
> +       default y
> +       help
> +         If you have a Frontpath ProGear say Y to enable the
> +         backlight driver.
>
> Should that be a default N or M, given that relatively few people have
> that device?

"default n" as this is rather rare used today device. Should I send 
a patch or can it be changed without it?

-- 
JID: hrw-jabber.org
OpenEmbedded developer/consultant

         Great minds discuss ideas; average minds discuss events;
         small minds discuss people.


