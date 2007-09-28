Return-Path: <linux-kernel-owner+w=401wt.eu-S1761276AbXI1Jps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276AbXI1Jps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbXI1JpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:45:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52738 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759703AbXI1JpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:45:20 -0400
Date: Fri, 28 Sep 2007 11:45:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Holzheu <holzheu@linux.vnet.ibm.com>,
       Joe Perches <joe@perches.com>, Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jesse Barnes <jesse.barnes@intel.com>, Arnd Bergmann <arnd@arndb.de>,
       Emil Medve <Emilian.Medve@freescale.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
Subject: Re: [RFC] New kernel-message logging API (take 2)
In-Reply-To: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709281139460.25099@fbirervta.pbzchgretzou.qr>
References: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 27 2007 23:18, Vegard Nossum wrote:
>  * kprint_<level>() is better than kprint(<level), ) because in the
>    case of the default log-level, the argument can be omitted.
>  * Memory allocated for entries and arguments is done in a ring-buffer
>    with variable-sized chunks. Arguments are chained with a singly-
>    linked list.
>  * Use SUBSYSTEM and KBUILD_MODNAME
>  * Rename kprint buffers to kprint blocks

This is overall, quite a lot. I suggest one-thing-at-a-time,
starting with kprint_<level>() that is compiled out if desired
and no fancy block or newline stuff.

_Then_, will see how it flies. All of this smells like a bit of
overdesigning, aka http://en.wikipedia.org/wiki/YAGNI
