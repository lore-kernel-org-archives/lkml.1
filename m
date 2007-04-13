Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbXDMPGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbXDMPGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 11:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbXDMPGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 11:06:11 -0400
Received: from mail35.syd.optusnet.com.au ([211.29.133.51]:51658 "EHLO
	mail35.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754035AbXDMPGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 11:06:10 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck list <ck@vds.kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Staircase Deadline cpu scheduler v 0.40
Date: Sat, 14 Apr 2007 01:05:54 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704140105.54354.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I'm alive and mostly well (yay!). I still should _not_ be spending extended 
periods on the computer for my neck but this last change was I believe 
essential and not too much effort.

Here's an update which should improve behaviour further with niced tasks.

http://ck.kolivas.org/patches/staircase-deadline/2.6.20.5-sd-0.40.patch
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc6-sd-0.40.patch
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc6-mm1-sd-0.40.patch

The last patch (which is for 2.6.21-rc6-mm1) can be used as an incremental 
from any 0.39 patched kernel.

Pretty much all of the architectural stuff for SD and bugfixes are done now. 
Barring bugs/fixes, I plan to start work on implementing SCHED_ISO and 
SCHED_IDLEPRIO for it for -ck over the next few weeks, but only once I'm 
_completely_ well, meaning extended periods offline again (sorry to those who 
are emailing me I'm not ignoring you intentionally!).

-- 
-ck
