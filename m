Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbXIHLNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbXIHLNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 07:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbXIHLM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 07:12:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:7419 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbXIHLMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 07:12:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=WSjYtW1RSS2V8MRUHZYp6nEs7AGs0fvEwwzdfTHM2vyhHHpMOeJbvhfSVE3gXW6xkaskRdB6d95ATaBiyE7H/YxBxPtTdBpSyNlT4Hlb1dhzk2O3hhwyhzfLM1xbsKm8bnl5GLShndlSkNtDD8eSfOWEJdbi7PJmfbOTwABUg/s=
Message-ID: <46E2835E.9010408@googlemail.com>
Date: Sat, 08 Sep 2007 13:11:26 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Arkadiusz Miskiewicz <arekm@maven.pl>,
       Thomas Voegtle <tv@lio96.de>, Soeren Sonnenburg <kernel@nn7.de>,
       Christian Leber <christian@leber.de>,
       kbuild-devel@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [4/4] 2.6.23-rc5: known regressions v2
References: <46E27DEF.7060109@googlemail.com>
In-Reply-To: <46E27DEF.7060109@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc5.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            10
Linus Torvalds                         6
Andi Kleen                             5
Hugh Dickins                           5
Trond Myklebust                        5
Andrew Morton                          4
Al Viro                                3
Alan Stern                             3
Alexey Starikovskiy                    3
Cornelia Huck                          3
David S. Miller                        3
Jens Axboe                             3
Stephen Hemminger                      3
Tejun Heo                              3



Kconfig/Kbuild

Subject         : building a specific in-tree module is currently a bit broken
References      : http://lkml.org/lkml/2007/9/5/40
Last known good : ?
Submitter       : Robert P. J. Day <rpjday@mindspring.com>
Caused-By       : ?
Handled-By      : Sam Ravnborg <sam@ravnborg.org>
Status          : problem is being debugged



Power management

Subject         : powersaving degradation, (time spend in C0 goes up after a while)
References      : http://lkml.org/lkml/2007/9/2/142
Last known good : ?
Submitter       : Christian Leber <christian@leber.de>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : something broke resume from s2ram on mbp c1d (??? :))
References      : http://lkml.org/lkml/2007/8/28/67
Last known good : 2.6.23-rc3
Submitter       : Soeren Sonnenburg <kernel@nn7.de>
Caused-By       : ?
Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
Status          : unknown

Subject         : 2.6.23-rc2 swsusp, suddenly increased uptime
References      : http://lkml.org/lkml/2007/8/12/249
Last known good : ?
Submitter       : Thomas Voegtle <tv@lio96.de>
Caused-By       : ?
Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
Status          : problem is being debugged

Subject         : resume from ram much slower
References      : http://lkml.org/lkml/2007/8/10/275
Last known good : 2.6.23-rc1 ?
Submitter       : Arkadiusz Miskiewicz <arekm@maven.pl>
Caused-By       : ?
Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
Status          : problem is being debugged



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
