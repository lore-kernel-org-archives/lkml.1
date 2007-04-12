Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbXDLSyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbXDLSyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 14:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXDLSyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 14:54:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43936 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbXDLSyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 14:54:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <461E8048.2010303@s5r6.in-berlin.de>
Date: Thu, 12 Apr 2007 20:54:00 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Carlo Florendo <subscribermail@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "menu" versus "menuconfig" -- they're *both* a bad idea
References: <Pine.LNX.4.64.0704110357200.9384@CPE00045a9c397f-CM001225dbafb6> <Pine.LNX.4.61.0704111059190.32056@yvahk01.tjqt.qr> <Pine.LNX.4.64.0704110509200.11343@CPE00045a9c397f-CM001225dbafb6> <461D84EB.7040207@gmail.com> <Pine.LNX.4.64.0704121118390.24425@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0704121118390.24425@CPE00045a9c397f-CM001225dbafb6>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> but it should be obvious that, if you look at the Kconfig files, each
> and every "select" directive has the potential to override a decision
> you think you might have made elsewhere.

In other words, the author of a Kconfig file should not assume he knows
best how users want to configure kernels.

IMO Kconfig files should be nothing more than a list of the existing
options with statements how they depend on each other, plus the inline
help texts, plus one default logical grouping (e.g. Drivers -> SCSI ->
most of the SCSI drivers).  All the rest, i.e. supporting users to get
to the desired configuration, should be left to the various UIs to
Kconfig --- including the bidirectional tracking of dependencies,
presentation in different logical groups than the default one, etc.

However, the trend here seems to be to turn Kconfig into a _program_ (a
script rather than a description), and to tune that program to the needs
of a subgroup of Kconfig endusers.

> I'm just sayin'.

Me 2.
-- 
Stefan Richter
-=====-=-=== -=-- -==--
http://arcgraph.de/sr/
