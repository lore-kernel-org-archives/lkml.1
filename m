Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXCCVEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXCCVEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932438AbXCCVEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:04:16 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:48107 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932395AbXCCVEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:04:15 -0500
Message-ID: <45E9E2BD.9070106@lwfinger.net>
Date: Sat, 03 Mar 2007 15:03:57 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-wireless@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] bcm43xx: do not rebuild when kernel version changes
References: <20070303190328.GA30463@uranus.ravnborg.org> <200703032121.43136.mb@bu3sch.de>
In-Reply-To: <200703032121.43136.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:
> On Saturday 03 March 2007 20:03, Sam Ravnborg wrote:
>> Replacing use of UTS_RELEASE with utsname()->release
>> avoids that this module is rebuild each
>> time the kernel version changes.
>>
>> Compile tested only.
> 
> I vote to get rid of the whole bcm43xx_ethtool.c file, as it's useless.
> It will vanish with the advent of d80211, anyway.
> Larry?

Is bcm43xx_ethtool.c really useless? If so, I vote to remove it. I have never tried to use ethtool
on bcm43xx. Similarly, it isn't very often that I recompile the kernel when bcm43xx hasn't changed
and would not have noticed the bug that Sam reported.

Larry

