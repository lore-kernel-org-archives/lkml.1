Return-Path: <linux-kernel-owner+w=401wt.eu-S1751623AbXDUSpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbXDUSpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 14:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbXDUSpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 14:45:18 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:55437 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbXDUSpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 14:45:17 -0400
Subject: Re: Kernel 2.6.20+ and rt2500/rt2570 problem
From: Ben Collins <ben.collins@ubuntu.com>
To: Wiktor Wandachowicz <siryes@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <254054bc0704210718t20ec96et3b7ab82ef783684f@mail.gmail.com>
References: <254054bc0704210718t20ec96et3b7ab82ef783684f@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 21 Apr 2007 14:45:13 -0400
Message-Id: <1177181113.6369.2.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-21 at 16:18 +0200, Wiktor Wandachowicz wrote:
> Recently I tried newer releases of Linux distributions, specifically
> Sabayon Linux 3.3 and Ubuntu 7.04. Both suffer from problems with
> rt2500/rt2570 modules not being able to associate with access points.
> There are numerous problems reported Ubuntu Launchpad, Gentoo Forums
> and Sabayon Forums.
> 
> Please, Linux kernel developers, try to help out the guys at:
> http://rt2x00.serialmonkey.com/
> 
> They look pretty clueless and don't know exactly what to do.
> It seems that advances in kernel to Wireless Extensions 19 broke
> their efforts somewhat.
> 
> If possible, speed up the inclusion process of the driver into mainline
> kernel, so users won't have to be forced to do a hardware upgrade.
> Additionally, this problem prevents my machines from being upgraded from
> Ubuntu 6.10 (kernel 2.6.17) to Ubuntu 7.04 (kernel 2.6.20 I believe).


There are two modules in Ubuntu for this chipset, the rt2500 (default)
and rt2500{pci,usb}. You could try blacklisting rt2500 and use
rt2500pci. See if that helps.

-- 
Ubuntu:    http://www.ubuntu.com/
Linux1394: http://www.linux1394.org/

