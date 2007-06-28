Return-Path: <linux-kernel-owner+w=401wt.eu-S1764811AbXF1Qja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764811AbXF1Qja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759236AbXF1QjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:39:23 -0400
Received: from hosting.zipcon.net ([209.221.136.3]:44709 "EHLO
	hosting.zipcon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758948AbXF1QjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:39:22 -0400
Message-ID: <4683E433.40000@beezmo.com>
Date: Thu, 28 Jun 2007 09:39:15 -0700
From: William D Waddington <william.waddington@beezmo.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Helge Hafting <helge.hafting@aitel.hist.no>, linux-kernel@vger.kernel.org,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Please release a stable kernel Linux 3.0
References: <fa.ZV8hYZHQHqzfx1dgOFeEVFRogSg@ifi.uio.no>	<oor483d2nqn6ae728com1v7v56g0ksotov@4ax.com>	<4683983E.5020103@aitel.hist.no>	<4683D3B0.1040708@beezmo.com> <20070628173051.4a3422c0@the-village.bc.nu>
In-Reply-To: <20070628173051.4a3422c0@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Alan Cox wrote:

[snip]

>> A cleaned-up, consistent, and out-of-tree friendly way of handling API
>> changes might help us all.
> 
> The problem is that its very impractical. If I change a kernel API I fix
> up the in tree users and test those I can, that's "accepted practice" -
> you make mess doing a job you clean it up. I can't do that for out of
> tree code because its out of tree.

Thanks for the thoughtful reply.  _And_ for taking the time to look at
the code.

I guess my half-assed notion is to have a single file w/"#ifdef-able"
entries that flag API changes.  It at least would give me/us a single
point of reference, and avoid the rather ugly version checking.  "LDDx"
is fine, and lwn.net has saved my ass more times than I can count, but a
single peg on which to hang my out-of-tree hat would seem useful.

Thanks again,
Bill
-- 
--------------------------------------------
William D Waddington
Bainbridge Island, WA, USA
william.waddington@beezmo.com
--------------------------------------------
"Even bugs...are unexpected signposts on
the long road of creativity..." - Ken Burtch
