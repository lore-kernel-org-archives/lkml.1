Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570Ab0AICxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab0AICxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 21:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788Ab0AICxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 21:53:07 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:57843 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab0AICxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 21:53:06 -0500
To: david@fromorbit.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.30 and later] file corruption on ext3 filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201001080254.o082sOXB018423@www262.sakura.ne.jp>
	<20100108123641.GB8654@discord.disaster>
	<201001082215.EJH52647.JLtFSFFVQOHMOO@I-love.SAKURA.ne.jp>
	<20100108151915.GC8654@discord.disaster>
In-Reply-To: <20100108151915.GC8654@discord.disaster>
Message-Id: <201001091153.FAC21374.OFOFMJQVOSFLtH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 9 Jan 2010 11:53:03 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> I agree that it is very wrong, but it's a known problem with writeback
> mode in ext3:
> 
> http://thread.gmane.org/gmane.linux.kernel/818044/focus=819977
> 
> More info as to how this change came about and the proposed but not
> yet realised fixes:
> 
> http://lwn.net/Articles/328363/

Thank you for the pointer.

Indeed, most Linux boxes are used by single user.
But implicitly importing other deleted file's data is still annoying
even if the box is used by only one user.

When I was trying to identify the steps to reproduce, I got ./a.out replaced
by the deleted .bash_history due to power failure. I executed ./a.out as root
without knowing that the file contains deleted .bash_history , and many
commands listed in deleted .bash_history are executed as root.
I thought my box was cracked and trojaned. :-(
