Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbZLFBmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbZLFBmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 20:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbZLFBmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 20:42:00 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:52981 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755188AbZLFBmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 20:42:00 -0500
Date: Sat, 05 Dec 2009 23:44:55 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, intel-gfx@lists.freedesktop.org,
       luto@myrealbox.com, benisty.e@gmail.com
Subject: Re: 2.6.31 -> 2.6.32 Sound and video regressions
Message-ID: <50CA8D92EC%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <4B1A6F78.8010408@myrealbox.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org, 
 intel-gfx@lists.freedesktop.org, luto@myrealbox.com, benisty.e@gmail.com,
 linux@youmustbejoking.demon.co.uk
User-Agent: Messenger-Pro/2.60.1.3104 (Qt/4.5.3) (Linux-x86_64)
X-NuLabour-Date: Sat, 9136 Dec 1984 23:44:55 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I demand that Andy Lutomirski may or may not have written...

> Emmanuel Benisty wrote:
[snip]
>> I just wanted to report 2 regressions I am having now with 2.6.32.
>> Video
>> Screen is flickering/glitching like crazy in X. It happens whether
>> randomly or when conky is refreshed, when the mouse cursor moves and
>> like hell when a page is loading in the browser. Not so easy to
>> describe this issue.
[snip]

> That sounds like FIFO underruns, which (I think) were introduced when
> self-refresh was enabled but should have been fixed. I personally have no
> clue how to fix them, but if you told the Intel people what kind of chip
> you have (lspci output), they can probably fix it.

It also sounds like what I'm seeing on my EeePC 901. It only happens after
resume, which makes STR a little less than useful; the display will, sooner
or later, show a single colour (which is, presumably, the result of a display
engine hang, as described in the comment immediately before
intel_calculate_wm) and, seemingly, be stuck like that until power-off or
reboot.

Whether it *is* the same problem, I couldn't say.

Needless to say, this problem goes away if I disable KMS.

-- 
| Darren Salt            | linux at youmustbejoking | nr. Ashington, | Doon
| using Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
| + http://www.youmustbejoking.demon.co.uk/ & http://tlasd.wordpress.com/

Dumb luck beats sound planning every time. Trust me.
