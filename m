Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbXBJXUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbXBJXUb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 18:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbXBJXUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 18:20:31 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:61297 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbXBJXUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 18:20:31 -0500
Date: Sat, 10 Feb 2007 17:20:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: NAK new drivers without proper power management?
In-reply-to: <fa.kop49l/7yexJoUGrzk6vVeIP934@ifi.uio.no>
To: nigel@nigel.suspend2.net, linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Message-id: <45CE533C.4010108@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
 <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no>
 <fa.DhkemAgVI60diqZy0t9GzpwyLmk@ifi.uio.no>
 <fa.E/NjHlgg0HqDg5CgZjnCHFi2AMM@ifi.uio.no>
 <fa.kop49l/7yexJoUGrzk6vVeIP934@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:
> If your device requires power management, and you know it requires power
> management, why not just implement power management? Doing -ENOSYS
> instead is like saying -ESPAMMEBECAUSEIMLAZY.
> 
> Let me put it another way: People keep talking about Linux being ready
> for the desktop. To me at least (but I dare say for lots of other people
> too), being ready for the desktop means that things just work, without
> having to recompile kernels or bug driver authors or wait twelve
> months. 
> 
> And it means that doing a bare minimum isn't enough. We keep claiming
> that Open Source is better than Proprietary software. If we accept
> half-pie jobs of implementing support for anything - driver power
> management support or hibernation support or whatever - as 'good
> enough', we're undercutting that argument. Linux's power management
> support should - as far as we're able - be at least as good as that
> other operating system's and preferably way, way better.
> 
> -ENOSYS is just not acceptable.

Well, it's probably more acceptable than silently doing nothing and the 
device failing or locking up the machine on resume, but I couldn't agree 
more that it's not what we want to be encouraging. Perfect may be the 
enemy of the good, but "works except no power management" is hardly what 
I would call good these days, more like pretty sloppy..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

