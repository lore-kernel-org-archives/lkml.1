Return-Path: <linux-kernel-owner+w=401wt.eu-S1764096AbXHXRjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764096AbXHXRjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763505AbXHXRik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:38:40 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:8533 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762998AbXHXRif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:38:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=losCdjEVllEL0sNjEMVEt0jYTA48kvTuCpNh/3/QQ9CBJzN+dpYA6Ig1gA9Vt1nQqgGId4PLvUrhEw2/RtwuHRhu50uA6080VMmAXIKDMgmoXLyQfl2/67gu43u9SjAWjEafFNqgFEbgU0wlSJrX1Tyq6q40PF7tWhZf9nm8hRw=
Message-ID: <46CF178C.4060506@googlemail.com>
Date: Fri, 24 Aug 2007 19:38:20 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org, Plamen Petrov <plamen.petrov@tk.ru.acad.bg>,
       Michael Sedkowski <sedmich@gmail.com>, dth <dth@dth.net>,
       linux-fsdevel@vger.kernel.org, nfs@lists.sourceforge.net,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Clayton <andrew@digital-domain.net>,
       Florin Iucha <florin@iucha.net>, Bret Towe <magnade@gmail.com>
Subject: Re: [2/4] 2.6.23-rc3: known regressions v3
References: <46CF0DEF.5040107@googlemail.com>
In-Reply-To: <46CF0DEF.5040107@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc3.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            9
Andi Kleen                             5
Linus Torvalds                         5
Andrew Morton                          4
Al Viro                                3
Alan Stern                             3
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3



ACPI

Subject         : MCFG bug on hp nx6310
References      : http://lkml.org/lkml/2007/8/8/252
Last known good : ?
Submitter       : Michael Sedkowski <sedmich@gmail.com>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : 2.6.23-rc1-git10 hangs on boot - needs "acpi=off"
References      : http://lkml.org/lkml/2007/8/2/24
Last known good : ?
Submitter       : Plamen Petrov <plamen.petrov@tk.ru.acad.bg>
Caused-By       : ?
Handled-By      : Len Brown <len.brown@intel.com>
Status          : problem is being debugged



CPUFREQ

Subject         : ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not
References      : http://lkml.org/lkml/2007/7/27/298
                  http://lkml.org/lkml/2007/7/29/371
Last known good : ?
Submitter       : dth <dth@dth.net>
Caused-By       : Len Brown <lenb@kernel.org>
                  commit f79e3185dd0f8650022518d7624c876d8929061b
Handled-By      : Len Brown <lenb@kernel.org>
Status          : problem is being debugged



FS

Subject         : nfs4 hang/NFS woes again
                  (was USB-related oops in sysfs with linux v2.6.23-rc3-50-g28e8351)
References      : http://lkml.org/lkml/2007/8/15/144
                  http://lkml.org/lkml/2007/8/22/484
                  http://lkml.org/lkml/2007/8/23/134
Last known good : ?
Submitter       : Florin Iucha <florin@iucha.net>
                  Bret Towe <magnade@gmail.com>
Caused-By       : Trond Myklebust <Trond.Myklebust@netapp.com>
                  commit 3d39c691ff486142dd9aaeac12f553f4476b7a62
Handled-By      : ?
Status          : problem is being debugged

Subject         : [NFSD OOPS] 2.6.23-rc1-git10
References      : http://lkml.org/lkml/2007/8/2/462
Last known good : ?
Submitter       : Andrew Clayton <andrew@digital-domain.net>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
