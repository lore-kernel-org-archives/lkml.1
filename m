Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbYLIJDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbYLIJDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 04:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYLIJDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 04:03:30 -0500
Received: from zimbra-mta.cetrtapot.si ([89.212.80.172]:53913 "EHLO
	zimbra-mta.cetrtapot.si" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYLIJD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 04:03:28 -0500
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 04:03:28 EST
Message-ID: <493E3275.4030905@cetrtapot.si>
Date: Tue, 09 Dec 2008 09:55:17 +0100
From: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: How to check for memory leaks
References: <493D9D24.8080406@lwfinger.net>
In-Reply-To: <493D9D24.8080406@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> What is the best way to check if there is a memory leak?
> 
> If I start a ping running on my system using the rtl8187 driver, and nothing
> else active on my system, I see an increase in the "slab" value in /proc/meminfo
> of about 65 kB/minute. Is this indicative of a memory leak? When I run the same
> test with p54usb, the increase is only 20 kB/min.
> 

Also see cat /proc/slabinfo (you need to compile some debugging feature to get access to 
/proc/slabinfo).

HTTH,
Hinko

-- 
Hinko Kočevar, OSS developer
ČETRTA POT, d.o.o.
Planina 3, 4000 Kranj, SI EU
tel     ++386 (0) 4 280 66 03
e-mail  hinko.kocevar@cetrtapot.si
http    www.cetrtapot.si

