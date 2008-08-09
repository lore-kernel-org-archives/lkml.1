Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYHIVUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYHIVUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 17:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYHIVT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 17:19:57 -0400
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:43384 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbYHIVT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 17:19:57 -0400
From: Frans Pop <elendil@planet.nl>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: Framebuffer drivers that break the boot on systemswithout the hardware
Date: Sat, 9 Aug 2008 23:19:42 +0200
User-Agent: KMail/1.9.9
Cc: adaplas@gmail.com, mingo@elte.hu, akpm@osdl.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <489DFACC.6030009@keyaccess.nl>
In-reply-To: <489DFACC.6030009@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808092319.43139.elendil@planet.nl>
X-OriginalArrivalTime: 09 Aug 2008 21:19:54.0315 (UTC) FILETIME=[AABC09B0:01C8FA65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Ingo Molnar posted a list of drivers he found to break the boot during
> testing of randconfig kernels and among them are a number of FB drivers:
> 
> FB_VESA

This one is set to "y" in the kernel configs for the generic Debian 
kernels for i386 and x86_64 and is used by default for the graphical 
version of the Debian Installer, so I'd be very surprised if it broke 
very many systems...
AFAIK it is only actually enabled if the 'vga=' boot parameter is passed.

Ingo's mail also lists FRAMEBUFFER_CONSOLE which again is set to "y" in 
Debian's standard kernel configs for x86 (and probably most other 
arches).

> (and FB_VIRTUAL)

This one should be fixed with 2.6.27-rc1. The commit that fixes it is:
  commit b604838ac6d233fd6bffc0e758a818133a01ff22
  Author: Frans Pop <elendil@planet.nl>
  Date:   Wed Jul 23 21:31:26 2008 -0700
    vfb: only enable if explicitly requested when compiled in

Cheers,
FJP
