Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZJPQee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZJPQee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 12:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZJPQed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 12:34:33 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:62490 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbZJPQed convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 12:34:33 -0400
Date: Fri, 16 Oct 2009 17:24:06 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: Re: Linux 2.6.32-rc5 - eeepc-laptop/rt2860 panic fix patches
Message-ID: <mpro.krm886004sbpc026m.linux@youmustbejoking.demon.co.uk>
Mail-Followup-To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
 Darren Salt <linux@youmustbejoking.demon.co.uk>
User-Agent: Messenger-Pro/2.60.0.3101 (Qt/4.5.2) (Linux-x86_64)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I demand that Linus Torvalds may or may not hae written...

> Darren Salt (2):
>      eeepc-laptop: Prevent a panic when disabling RT2860 wireless when
>        associated

This patch (commit b56ab33d68638e6aafdbfc694025e8354a628f49) causes problems
with at least some alternative hardware, and should be reverted. I found that
if I substitute an Intel 3945 for the RT2860 in my 901 then, when eeepc-wlan
is toggled, we get rfkill set → eeepc-laptop → iwl3945 → rfkill remove (and
one process stuck in state D), and if I flip the flag which causes this, that
works fine but rt2860sta will happily cause a panic again.

Both I and Corentin Chary have unsuccessfully tried to get this patch
dropped.

>      Staging: rt2860sta: prevent a panic when disabling when associated

It has been superseded by this patch (commit
0af49167b1e5ba154e90d2c454bf4624ee47df80).

-- 
| Darren Salt            | linux at youmustbejoking | nr. Ashington, | Doon
| using Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
| + Buy local produce. Try to walk or cycle. TRANSPORT CAUSES GLOBAL WARMING.

I know a good tagline when I steal one.
