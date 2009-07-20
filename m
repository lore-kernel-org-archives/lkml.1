Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZGTVTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZGTVTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZGTVTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:19:11 -0400
Received: from superlopez.pirispons.net ([94.23.80.139]:39376 "EHLO
	superlopez.pirispons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbZGTVTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:19:10 -0400
Date: Mon, 20 Jul 2009 23:19:09 +0200
From: Kiko Piris <kernel@pirispons.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
       Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.30.2: does not boot
Message-ID: <20090720211908.GA31814@superlopez.pirispons.net>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
	Wolfgang Walter <wolfgang.walter@stwm.de>,
	linux-kernel@vger.kernel.org
References: <20090720040813.GC11940@kroah.com>
 <200907201613.22483.wolfgang.walter@stwm.de>
 <20090720150916.GB10015@suse.de>
 <20090720180333.GA2905@brouette>
 <20090720192933.GA22641@superlopez.pirispons.net>
 <alpine.LFD.2.01.0907201241490.19335@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.01.0907201241490.19335@localhost.localdomain>
User-Agent: Mutt
X-No-CC: Please respect my Mail-Followup-To header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/07/2009 at 12:50 -0700, Linus Torvalds wrote:

> Just to clarify:
> 
>  - you literally have a _working_ 2.6.30.1 that you compiled yourself a 
>    few days ago.

That’s correct.

>  - But when you try to compile that same kernel _now_, it fails with an 
>    immediate reboot? And not just 2.6.30.2, but 2.6.30.1 does that too?

Also correct.

> That certainly implies something else than just the -fwrapv vs 
> -fno-strict-overflow thing.

Yes, as Marcel Beister pointed, it resulted some binutils bug.
Downgrading the package produced a perfectly bootable 2.6.30.2.

> But we may be looking at two different issues, so maybe your "unable to 
> compile a working kernel" issue is different from the other reports.

Totally unrelated to other reports, and not a kernel bug, in fact.

Sorry if caused any confussion.

-- 
Kiko
