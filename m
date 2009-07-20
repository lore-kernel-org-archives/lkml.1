Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZGTWOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZGTWOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 18:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZGTWOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 18:14:09 -0400
Received: from superlopez.pirispons.net ([94.23.80.139]:59958 "EHLO
	superlopez.pirispons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbZGTWOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 18:14:08 -0400
Date: Tue, 21 Jul 2009 00:14:07 +0200
From: Kiko Piris <kernel@pirispons.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
       Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.30.2: does not boot
Message-ID: <20090720221407.GA3383@superlopez.pirispons.net>
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
 <20090720211908.GA31814@superlopez.pirispons.net>
 <alpine.LFD.2.01.0907201458000.19335@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.01.0907201458000.19335@localhost.localdomain>
User-Agent: Mutt
X-No-CC: Please respect my Mail-Followup-To header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/07/2009 at 15:02 -0700, Linus Torvalds wrote:

> It seems that all the people involved are running Debian/sid, and I don't 
> think we have any firm confirmation yet that it's the compiler flag for 
> anybody. It was certainly the primary suspect, but maybe that was always 
> just a red herring guess.
>
> Wolfgang hasn't actually tried to compile without the -fno-strict-overflow 
> flag yet, and maybe his hang is the same binutils bug.

Just in case this information could be of any help:

I compiled 2.6.30.2 but reverting that commit
(a137802ee839ace40079bebde24cfb416f73208a, “Dont use -fwrapv compiler
option: its buggy in gcc-4.1.x”); on my sid box (with that supposedly
bad version of binutils), the box did not boot (same behaviour: reboot
just after lilo).

I also compiled 2.6.27.27 (it has that very same commit) on 3 different
servers at work (debian stable there). All of them booted without any
problem.

All of my boxes seem to be ok, but if I can do any additional test to
help, please let me know.

Thanks!

-- 
Kiko
