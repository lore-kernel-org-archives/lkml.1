Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214Ab0AaKbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab0AaKbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 05:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263Ab0AaKbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 05:31:52 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:59902 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0AaKbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 05:31:52 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B655C08.3020504@s5r6.in-berlin.de>
Date: Sun, 31 Jan 2010 11:31:36 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: =?UTF-8?B?0JjQu9GM0Y8g0JHQsNGB0LjQvQ==?= <basinilya@gmail.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: net: fix panic in fwnet_write_complete
References: <574312453.20100114002526@gmail.com> <4B4E4D73.5060100@s5r6.in-berlin.de> <4B4E4FD7.9060403@s5r6.in-berlin.de> <4B53291A.5050901@s5r6.in-berlin.de> <1833218156.20100118151651@gmail.com> <4B547154.40700@s5r6.in-berlin.de> <tkrat.a8b022df2a5d588d@s5r6.in-berlin.de> <4B54FFF9.9000906@s5r6.in-berlin.de> <4B5F4C10.9040300@s5r6.in-berlin.de> <221196491.20100131124528@gmail.com>
In-Reply-To: <221196491.20100131124528@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Илья Басин wrote:
> SR> Stefan Richter wrote:
> SR> I am going to send a pull request for some other unrelated firewire
> SR> fixes to Linus about tomorrow.
[...]
> SR> What is your impression --- does this first incomplete fix decrease the
> SR> likelihood of crashes enough to make it worth to include it in a pull
> SR> request already?  I haven't done more extensive firewire-net tests since
> SR> last week yet, hence it is hard to tell for me how severe the new issue
> SR> is in practical use.
[...]
> Hi. Have just found 4 letters from you in gmail spam bin, including
> this one.

(One reason may be that my mail service provider occasionally gets
blacklisted in SORBS, perhaps other DNSBLs.  Or they distrust kyrillic
letters in mails from .de or whatever.)

> Your fix does decrease the chance of crash. Without the fix
> crashes randomly occured within 3 minutes. With the fix - only after
> 10 minutes of copying. These 2 bugs are probably unrelated.

OK.  The patch didn't make it into 2.6.33-rc6 from last Friday but I
will see to it that it gets merged before the final release.  I will
also try to find time to learn more about the other bug.
-- 
Stefan Richter
-=====-==-=- ---= =====
http://arcgraph.de/sr/
