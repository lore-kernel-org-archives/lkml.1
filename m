Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbXIPT6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbXIPT6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 15:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXIPT6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 15:58:33 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57097 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXIPT6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 15:58:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46ED8AD0.2040004@s5r6.in-berlin.de>
Date: Sun, 16 Sep 2007 21:58:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, Ben Collins <ben.collins@ubuntu.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>
Subject: Re: regression: fireware causes oops during system
References: <20070911190043.GA1577@elf.ucw.cz> <20070916175424.GB11983@elf.ucw.cz> <46ED78DF.2020609@s5r6.in-berlin.de> <200709162152.24793.rjw@sisk.pl>
In-Reply-To: <200709162152.24793.rjw@sisk.pl>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>> Pavel Machek wrote:
>>> commit 831441862956fffa17b9801db37e6ea1650b0f69
>>> tree b0334921341f8f1734bdd3243de76d676329d21c
>>> parent 787d2214c19bcc9b6ac48af0ce098277a801eded
>>> author Rafael J. Wysocki <rjw@sisk.pl> Tue, 17 Jul 2007 04:03:35 -0700
>>> committer Linus Torvalds <torvalds@woody.linux-foundation.org> Tue, 17
>>> Jul 2007 10:23:02 -0700
>>>
>>>     Freezer: make kernel threads nonfreezable by default
> 
> Well, I don't think so.
> 
> nodemgr_host_thread() calls set_freezable() as it should.

This commit is certainly OK, as it should merely preserve status quo.
Also note that Pavel wrote in his initial post that the problem became
apparent way after -rc1.  Full quote:

| I noticed empty suspend stopped working around 2.6.23-rc4, and it is
| still present in 2.6.23-rc6. To reproduce
|
| swapoff -a
| echo disk > /sys/power/state
| echo disk > /sys/power/state
|
| Unsetting
|
| CONFIG_IEEE1394=y
|
| solves the problem.

-- 
Stefan Richter
-=====-=-=== =--= =----
http://arcgraph.de/sr/
