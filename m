Return-Path: <linux-kernel-owner+w=401wt.eu-S1030518AbXAZAJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030518AbXAZAJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 19:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030661AbXAZAJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 19:09:17 -0500
Received: from sigma957.CIS.McMaster.CA ([130.113.64.83]:36628 "EHLO
	sigma957.cis.mcmaster.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030660AbXAZAJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 19:09:16 -0500
X-Greylist: delayed 5573 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 19:09:16 EST
Date: Thu, 25 Jan 2007 17:34:31 -0500 (EST)
From: Mark Hahn <hahn@mcmaster.ca>
X-X-Sender: hahn@coffee.psychology.mcmaster.ca
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
In-Reply-To: <Pine.LNX.4.64.0701250407590.3673@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0701251731160.20455@coffee.psychology.mcmaster.ca>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
 <20070122133735.GB4493@ucw.cz> <Pine.LNX.4.64.0701221348020.11525@p34.internal.lan>
 <Pine.LNX.4.64.0701241837550.2930@p34.internal.lan> <20070125003242.GA23343@elf.ucw.cz>
 <Pine.LNX.4.64.0701250407590.3673@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-PMX-Version-Mac: 4.7.1.128075, Antispam-Engine: 2.4.0.264935, Antispam-Data: 2007.1.25.140433
X-PerlMx-Spam: Gauge=IIIIIII, Probability=7%, Report='__CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Something is seriously wrong with that OOM killer.

do you know you don't have to operate in OOM-slaughter mode?

"vm.overcommit_memory = 2" in your /etc/sysctl.conf puts you 
into a mode where the kernel tracks your "committed" memory 
needs, and will eventually cause some allocations to fail.
this is often much nicer than the default random OOM slaughter.
(you probably also need to adjust vm.overcommit_ratio with 
some knowlege of your MemTotal and SwapTotal.)

regards, mark hahn.
