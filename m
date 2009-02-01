Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbZBANU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbZBANU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 08:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZBANUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 08:20:50 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:33605 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbZBANUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 08:20:49 -0500
Message-ID: <4985A1C9.4050005@krogh.cc>
Date: Sun, 01 Feb 2009 14:21:13 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.27.13
References: <20090125004823.GA6711@kroah.com>
In-Reply-To: <20090125004823.GA6711@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> We (the -stable team) are announcing the release of the 2.6.27.13
> kernel.
> 
> It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
> series are strongly encouraged to upgrade.
> 
> I'll also be replying to this message with a copy of the patch between
> 2.6.27.12 and 2.6.27.13
> 
> The updated 2.6.27.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

This may be just noise, but recently I have begun seeing Zombie 
processes hanging on some nodes in the computescluster:

2006      2055  0.0  0.0   9144  1260 ?        Ss   07:24   0:00      \_ 
-bash /z/gridengine/default/spool/node30/job_scripts/692747
2006      2060 39.0 38.7 1696468 1573884 ?     S    07:24 160:21 
   \_ /usr/bin/perl /z/home/trunk//bin/workqueue/worker
2006      2225  0.0  0.0      0     0 ?        Z    07:29   0:00 
       \_ [sh] <defunct>

ps faux output.

Killing the parent process makes it go awasy, but this one has been 
sitting there for almost 7 hours by now, without going away, essentially 
hagning this process.

Any suggestions?
-- 
Jesper
