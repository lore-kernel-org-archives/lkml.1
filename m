Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbYIDMOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbYIDMOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYIDMOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:14:12 -0400
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:58593 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752177AbYIDMOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:14:11 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] ncurses based config
To: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Nir Tzachar <tzachar@grad120a.cs.bgu.ac.il>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Nir Tzachar <nir@tzachar.com>
Reply-To: 7eggert@gmx.de
Date: Thu, 04 Sep 2008 14:21:38 +0200
References: <b86dt-3nV-39@gated-at.bofh.it> <b86wB-3HU-1@gated-at.bofh.it> <b86Qa-4k2-53@gated-at.bofh.it> <b879t-4DG-23@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1KbDqF-0003oH-1B@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alejandro Riveira Fernández <ariveira@gmail.com> wrote:
> El Wed, 3 Sep 2008 13:02:42 -0700 (PDT)

[nconfig]

>> I'm seeing cyan (?) foreground on black background.  Is that the colors
>> that were planned?
>   
>  much nicer colors here (ubuntu)
>  http://img177.imageshack.us/my.php?image=pantallazonm7.png

Desaturate the image using "luminosity" setting, and you'll spot a problem.

Choosing a non-black background isn't bad per se, but it limits the number of
colors you can use for foreground, and a dark grey isn't much better.

Generally you should use no color unless you'd like to draw attention. Use
blue for unimportant things, red if you want to alert. Never use red and blue
close to each other, because they need different focussing in the eye, and
trying to see both will cause a headache.

The layout is possibly good for large screen sizes, but you should design it
for 80x24 first. Having to install X11 or a framebuffer console just to
configure a kernel is no good.

In other words: You don't permanently need half a screen of instructions,
hide them by default and offer a popup. The window below the title is the
only working area, it can be maximized. (Looking at "make menuconfig",
I see the same mistakes.)


