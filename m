Return-Path: <linux-kernel-owner+w=401wt.eu-S965337AbXBUExs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337AbXBUExs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 23:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965330AbXBUExs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 23:53:48 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37975 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965113AbXBUExs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 23:53:48 -0500
Date: Tue, 20 Feb 2007 20:53:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.21-rc1
Message-ID: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, the merge window for 2.6.21 has closed, and -rc1 is out there.

There's a lot of changes, as is usual for an -rc1 thing, but at least so 
far it would seem that 2.6.20 has been a good base, and I don't think we 
have anything *really* scary here.

The most interesting core change may be the dyntick/nohz one, where timer 
ticks will only happen when needed. It's been brewing for a _loong_ time, 
but it's in the standard kernel now as an option. 

But there's a ton of architecture updates (arm, mips, powerpc, x86, you 
name it), ACPI updates, and lots of driver work. And just a lot of 
cleanups.

Have fun,

			Linus
