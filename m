Return-Path: <linux-kernel-owner+w=401wt.eu-S1763016AbXF1P3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763016AbXF1P3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbXF1P2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:28:53 -0400
Received: from hosting.zipcon.net ([209.221.136.3]:40523 "EHLO
	hosting.zipcon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745AbXF1P2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:28:52 -0400
Message-ID: <4683D3B0.1040708@beezmo.com>
Date: Thu, 28 Jun 2007 08:28:48 -0700
From: William D Waddington <william.waddington@beezmo.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Helge Hafting <helge.hafting@aitel.hist.no>
CC: linux-kernel@vger.kernel.org, Al Boldi <a1426z@gawab.com>
Subject: Re: Please release a stable kernel Linux 3.0
References: <fa.ZV8hYZHQHqzfx1dgOFeEVFRogSg@ifi.uio.no> <oor483d2nqn6ae728com1v7v56g0ksotov@4ax.com> <4683983E.5020103@aitel.hist.no>
In-Reply-To: <4683983E.5020103@aitel.hist.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hosting.zipcon.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - beezmo.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Helge Hafting wrote:
> Bill Waddington wrote:
>> (And taking my drivers main-line isn't an option.  It would be fine
>> with me, but there is *zero* chance that my funky code would be
>> welcomed into the tree.)
>>   
> If the only merge-stopper is code quality, why not
> post your driver and get some feedback?  Cleaning up code
> will take some effort of course;
> but once it is done, you're protected from module API changes. . .

Fair enough:
http://www.tahomatech.com/downloads/drivers/linux_2.6/pci/x86/compressed_tarfiles/
or for your browsing pleasure:
http://www.tahomatech.com/downloads/drivers/linux_2.6/pci/x86/files/

But I really don't see much hope :(  Coding style, masses of ioctls,
build and install technique,  limited user base, etc, etc, etc...  Most
of the above to keep API compatibility with other OS/older drivers -
back to SunOS 4.1.3.  (BTW, it does seem to work...)

And I probably have the license wrong.  The code has always been in
the public domain.  (Advice welcome...)

It really isn't that important to me to get this into the mainline,
or to have a stable kernel API.  I _might_ argue that a stable and
well documented kernel API (DKI) is a sign of a grown-up OS, but I
won't :)  It isn't that hard to recode for API changes.  There's always
LDD17 or 18 or 99 or whatever...

My (mild) beef is more like what I take to be Al's point: it feels like
there is a kind of hostility toward out-of-tree maintainers.  Why not
encourage _all_ of us who are beavering away at open-source code?  My
stuff doesn't belong in mainline, but it _is_ open, and in some minor
way allows more folks to run Linux.

A cleaned-up, consistent, and out-of-tree friendly way of handling API
changes might help us all.

Thanks for listening,
Bill

-- 
--------------------------------------------
William D Waddington
Bainbridge Island, WA, USA
william.waddington@beezmo.com
--------------------------------------------
"Even bugs...are unexpected signposts on
the long road of creativity..." - Ken Burtch
