Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbXIHLMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbXIHLMp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 07:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXIHLMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 07:12:35 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:46093 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbXIHLMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 07:12:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=oBbSLpgoDcK9/ht8Gxxfb/MROGDHXg+1pKYmpgEi2q1fkyj6JPm+kpCdp139o6K7l/NcRcuOGl9atDRNuKj/48rxuv8qrp3kbZSFYwOqGirFYlaIA63xFytsSinhz1rTdt1kVcwUpBTkp7eDEI43gRcrDh3V47/4vXuKws+8ocY=
Message-ID: <46E28343.1030002@googlemail.com>
Date: Sat, 08 Sep 2007 13:10:59 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Markus <lists4me@web.de>, Jeff Chua <jeff.chua.linux@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, linux-alpha@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stefan Becker <Stefan.Becker@nokia.com>, Andi Kleen <ak@suse.de>,
       Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, "" <tglx@linutronix.de>,
       Jakub Jelinek <jakub@redhat.com>, Jeff Dike <jdike@linux.intel.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       Adrian Bunk <bunk@kernel.org>
Subject: [1/4] 2.6.23-rc5: known regressions v2
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



Unclassified

Subject         : x86_64 vdso patch is broken somehow?
References      : http://lkml.org/lkml/2007/8/29/136
Last known good : ?
Submitter       : Chuck Ebbert <cebbert@redhat.com>
Caused-By       : Andi Kleen <ak@suse.de>
                  commit 2aae950b21e4bc789d1fc6668faf67e8748300b7
Handled-By      : ?
Status          : unknown

Subject         : cpu hotplug support broken in 2.6.23-rc3/highres timers break cpu hotplug in 2.6.23-rc5
References      : http://lkml.org/lkml/2007/8/27/58
                  http://lkml.org/lkml/2007/9/3/65
Last known good : ?
Submitter       : Pavel Machek <pavel@ucw.cz>
Caused-By       : ?
Handled-By      : ?
Status          : problem is being debugged

Subject         : 2.6.23-rc3-git1 crash/stuck on VIA CN700 system
References      : http://lkml.org/lkml/2007/8/20/174
Last known good : ?
Submitter       : Stefan Becker <Stefan.Becker@nokia.com>
Caused-By       : Andi Kleen <ak@suse.de>
                  commit 19d36ccdc34f5ed444f8a6af0cbfdb6790eb1177
Handled-By      : Andi Kleen <ak@suse.de>
                  Dave Jones <davej@redhat.com>
Workaround      : http://lkml.org/lkml/2007/9/5/221
Status          : problem is being debugged

Subject         : console is messed up after resume from s2ram or switching to console from X
References      : http://lkml.org/lkml/2007/8/4/6
Last known good : ?
Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
Caused-By       : ?
Handled-By      : H. Peter Anvin <hpa@zytor.com>
                  Antonino A. Daplas <adaplas@gmail.com>
Workaround      : "s2ram --force --acpi_sleep 1 --vbe_mode"
Status          : problem is being debugged

Subject         : konqueror suddenly vanishing, "konqueror: Fatal IO error: client killed"
References      : http://lkml.org/lkml/2007/7/22/86
Last known good : ?
Submitter       : Markus <lists4me@web.de>
Caused-By       : ?
Handled-By      : Ingo Molnar <mingo@elte.hu>
Status          : problem is being debugged

Subject         : uml on x86_64 compile error
References      : http://lkml.org/lkml/2007/9/3/86
Last known good : ?
Submitter       : Adrian Bunk <bunk@kernel.org>
Caused-By       : Jeff Dike <jdike@linux.intel.com>
                  commit d1254b12c93e1e586137a2ffef71fd33cf273f35
Handled-By      : ?
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
