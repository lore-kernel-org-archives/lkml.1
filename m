Return-Path: <linux-kernel-owner+w=401wt.eu-S967948AbXILRBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967948AbXILRBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934900AbXILRAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:00:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:18787 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934887AbXILQ77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 12:59:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=UCNCqniOv/UTtxpEHmwqnpTBvjCbSZf+P9o7DKOgwL4ZEa87T1niVeePRoB6H0X8IlDK+76CH8LmXF3msVRYRbuEK6AmVBTSpyEv2g7bdreIkLCH/HAr6RVCp5PHNhGdl3O5gFFAIbzx9pp5W7WYO0kylowTZUF/mf+Ts9c1f9A=
Message-ID: <46E81ADC.4030902@googlemail.com>
Date: Wed, 12 Sep 2007 18:59:08 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Arkadiusz Miskiewicz <arekm@maven.pl>,
       Thomas Voegtle <tv@lio96.de>, Soeren Sonnenburg <kernel@nn7.de>,
       Christian Leber <christian@leber.de>, Alan Cox <alan@redhat.com>,
       David Miller <davem@davemloft.net>, Andy Whitcroft <apw@shadowen.org>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [4/4] 2.6.23-rc6: known regressions
References: <46E8187E.9000006@googlemail.com>
In-Reply-To: <46E8187E.9000006@googlemail.com>
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
Linus Torvalds                         6
Alan Stern                             5
Andi Kleen                             5
Hugh Dickins                           5
Trond Myklebust                        5
Andrew Morton                          4
Al Viro                                3
Alexey Starikovskiy                    3
Cornelia Huck                          3
David S. Miller                        3
Jens Axboe                             3
Stephen Hemminger                      3
Tejun Heo                              3



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



TTY things

Subject         : 2.6.23-rc6-git1 -- termios *_1 compile failures on powerpc
References      : http://lkml.org/lkml/2007/9/12/101
Last known good : ?
Submitter       : Andy Whitcroft <apw@shadowen.org>
Caused-By       : David Miller <davem@davemloft.net>
                  commit f629307c857c030d5a3dd777fee37c8bb395e171
Handled-By      : ?
Status          : unknown



USB

Subject         : 2.6.23-rc1: USB hard disk broken
References      : http://lkml.org/lkml/2007/7/25/62
Last known good : ?
Submitter       : Tino Keitel <tino.keitel@gmx.de>
Caused-By       : ?
Handled-By      : Oliver Neukum <oliver@neukum.org>
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
