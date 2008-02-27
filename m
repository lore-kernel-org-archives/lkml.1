Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbYB0MdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbYB0MdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 07:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbYB0MdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 07:33:05 -0500
Received: from hpsmtp-eml18.KPNXCHANGE.COM ([213.75.38.118]:39747 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151AbYB0MdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 07:33:04 -0500
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Intel 945GM: 2.6.25-rc3 report (with a possible regression)
Cc: linux-kernel@vger.kernel.org, romanol@upcomillas.es
In-reply-To: <47C4AEDC.80600@s5r6.in-berlin.de>
References: <1204056556.7745.22.camel@localhost> <1204056556.7745.22.camel@localhost> <47C4AEDC.80600@s5r6.in-berlin.de>
Message-Id: <E1JULSV-0001qy-7N@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Wed, 27 Feb 2008 13:32:27 +0100
X-OriginalArrivalTime: 27 Feb 2008 12:32:27.0492 (UTC) FILETIME=[D0031240:01C8793C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Romano Giannetti wrote:
>> 1) The minor regression is that I cannot have any more a correct
>> console. I tried a lot of combinations, but without a framebuffer,
>> console is garbled by ubuntu splash and/or X.
> 
> Are you sure that this is a kernel regression, not a xf86-video-i810
> regression?

Yes, the X.Org developers are making major changes ATM and there have
definitely been regressions because of them.

Best way to find out is to check whether booting with an earlier kernel
solves the problem. If it does, it's most likely a kernel issue. If it
does not, it's most likely an X.Org issue.
 
> (On Gentoo, switching from X to console works with xf86-video-i810-2.1.1
> but results in a black screen with xf86-video-i810-2.2.0.90.)

This sounds like that could be a bug I filed recently and which was solved
in 2.2.1: http://bugs.freedesktop.org/show_bug.cgi?id=14481.

Cheers,
FJP
