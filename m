Return-Path: <linux-kernel-owner+w=401wt.eu-S932732AbXIOC3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732AbXIOC3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 22:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXIOC3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 22:29:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:20223 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXIOC3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 22:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=b+BOUQFBlAq5Hx4cYYpCyO2L1daZB5BwI5KdtyRSkqepHY95eYzMD4LSJgdiHQWKeFjAzf1SFHU/HNF3636gA4Xj3IuiKgZoSgJHP/I4z2aDOf6I7VHRmiepnNCsQ2te1SKysWQZZ8eMz/FohkmW6I6NLfEwj8ws36ev5rYU8Kg=
Message-ID: <46EB436E.6030509@googlemail.com>
Date: Sat, 15 Sep 2007 04:29:02 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <lenb@kernel.org>,
       dth <dth@dth.net>, linux1394-devel@lists.sourceforge.net,
       Ben Collins <ben.collins@ubuntu.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, Pavel Machek <pavel@ucw.cz>
Subject: [1/3] 2.6.23-rc6: known regressions v2
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc6.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            10
Andi Kleen                             7
Linus Torvalds                         6
Alan Stern                             5
Hugh Dickins                           5
Trond Myklebust                        5
Andrew Morton                          4
David S. Miller                        4
Al Viro                                3
Alexey Starikovskiy                    3
Cornelia Huck                          3
Jens Axboe                             3
Stephen Hemminger                      3
Tejun Heo                              3



Unclassified

Subject         : crashme fault
References      : http://lkml.org/lkml/2007/9/13/19
Last known good : ?
Submitter       : Randy Dunlap <randy.dunlap@oracle.com>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : cpu hotplug support broken in 2.6.23-rc3/highres timers break cpu hotplug in 2.6.23-rc5
References      : http://lkml.org/lkml/2007/8/27/58
                  http://lkml.org/lkml/2007/9/3/65
Last known good : ?
Submitter       : Pavel Machek <pavel@ucw.cz>
Caused-By       : ?
Handled-By      : Thomas Gleixner <tglx@linutronix.de>
Status          : problem is being debugged

Subject         : console is messed up after resume from s2ram or switching to console from X
References      : http://lkml.org/lkml/2007/8/4/6
                  http://lkml.org/lkml/2007/9/13/227
Last known good : ?
Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
Caused-By       : ?
Handled-By      : H. Peter Anvin <hpa@zytor.com>
                  Antonino A. Daplas <adaplas@gmail.com>
Workaround      : "s2ram --force --acpi_sleep 1 --vbe_mode"
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



FireWire

Subject         : empty suspend stopped working around 2.6.23-rc4
References      : http://lkml.org/lkml/2007/9/11/326
Last known good : ?
Submitter       : Pavel Machek <pavel@ucw.cz>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Farewell!
Michal

--
LOGOUT
http://www.stardust.webpages.pl/
