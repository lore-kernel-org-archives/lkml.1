Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179Ab0ANLFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab0ANLFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163Ab0ANLFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:05:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160Ab0ANLFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:05:42 -0500
Message-ID: <4B4EFA82.1090506@suse.cz>
Date: Thu, 14 Jan 2010 12:05:38 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, Oliver Hartkopp <oliver@hartkopp.net>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Bug #14907] Commit "kbuild: fix bzImage build for x86" breaks
 build
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.lV.kNlSLB@chimera> <20100111013606.GA7031@progeny.tock> <4B4DBD8B.6000002@suse.cz>
In-Reply-To: <4B4DBD8B.6000002@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.1.2010 13:33, Michal Marek wrote:
> On 11.1.2010 02:36, Jonathan Nieder wrote:
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
>>
>> I am using the patch without problems, but it is not in the mainline
>> as of v2.6.33-rc3-git3.  So please do keep the bug listed.
> 
> I resent the pull request (http://lkml.org/lkml/2010/1/13/194), let's see.

FYI:
commit 04e9e5c7659ee07f0387ddb663913fadcca88d5f
Merge: cedabed 0710520
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jan 13 16:09:59 2010 -0800

    Merge branch 'for-33' of git://repo.or.cz/linux-kbuild

    * 'for-33' of git://repo.or.cz/linux-kbuild:
      Makefile: do not override LC_CTYPE
      kbuild: really fix bzImage build with non-bash sh

Michal
