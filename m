Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857Ab0ALJCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab0ALJCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844Ab0ALJC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:02:27 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:28131 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab0ALJCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:02:24 -0500
X-RZG-AUTH: :I2ANY0W6W/eA95XfH/xfO6gOxLxTty/udEMngcJ/VAKW22+lDNBZ3PpxHKw7vRA=
X-RZG-CLASS-ID: mo00
Message-ID: <4B4C3A82.8080802@hartkopp.net>
Date: Tue, 12 Jan 2010 10:01:54 +0100
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jonathan Nieder <jrnieder@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Bug #14907] Commit "kbuild: fix bzImage build for x86" breaks
 build
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.lV.kNlSLB@chimera> <20100111013606.GA7031@progeny.tock> <201001112102.13570.rjw@sisk.pl>
In-Reply-To: <201001112102.13570.rjw@sisk.pl>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday 11 January 2010, Jonathan Nieder wrote:
>> Rafael J. Wysocki wrote:
>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.32.  Please verify if it still should be listed and let me know
>>> (either way).
>>>
>>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14907
>>> Subject		: Commit "kbuild: fix bzImage build for x86" breaks build
>>> Submitter	: Oliver Hartkopp <oliver@hartkopp.net>
>>> Date		: 2009-12-19 19:21 (23 days old)
>>> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4a2ff67c88211026afcbdbc190c13f705dae1b59
>>> References	: http://marc.info/?l=linux-kernel&m=126125050622195&w=4
>>> 		  http://marc.info/?l=linux-kernel&m=126114565103300&w=4
>>> 		  http://marc.info/?l=linux-kbuild&m=126202819526623&w=2
>>> Handled-By	: Jonathan Nieder <jrnieder@gmail.com>
>>> Patch		: http://thread.gmane.org/gmane.linux.kbuild.devel/4313/focus=4319
>>> 		  http://patchwork.kernel.org/patch/71957/
>> I am using the patch without problems, but it is not in the mainline
>> as of v2.6.33-rc3-git3.  So please do keep the bug listed.
> 
> I will, thanks for the update.

I just tested the patch again - and it fixes the problem.

You can add my

Tested-by: Oliver Hartkopp <oliver@hartkopp.net>

if you like.

Thanks,
Oliver

