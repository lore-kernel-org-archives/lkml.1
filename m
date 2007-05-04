Return-Path: <linux-kernel-owner+w=401wt.eu-S1161569AbXEDUKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161569AbXEDUKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161584AbXEDUKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:10:51 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:36644
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161569AbXEDUKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:10:50 -0400
Message-ID: <463BA19F.8010500@microgate.com>
Date: Fri, 04 May 2007 15:11:59 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tty add compat_ioctl
References: <1178213683.4369.3.camel@amdx2.microgate.com> <200705040223.46326.arnd@arndb.de>
In-Reply-To: <200705040223.46326.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> - The return value of the new compat_ioctl methods should probably
> 'int', not 'long'. We've had the discussion before and then
> decided not to change the existing compat_ioctl and 
> unlocked_ioctl functions -- even though int is more appropriate,
> but having the same prototype has the advantage that a driver
> can use the same function for both ->ioctl and ->compat_ioctl
> if all calls are compatible.

Any comments on this or should I assume that
compat_ioctl() will stay with ulong return type?

-- 
Paul Fulghum
Microgate Systems, Ltd.
