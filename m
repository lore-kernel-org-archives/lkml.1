Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbXGWJuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbXGWJuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 05:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757401AbXGWJto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 05:49:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:13353 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629AbXGWJtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 05:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=EGB0xRkDiNrRD4jgNSw8xlqLLZ31tqy5fUHipMuCxMbHicAnWV6QmRqOZIanAkfRhm5BNjPz+2lTRDL2pRK5w/gn1/GFQ+dLfxomd2JfKL1pcpDrABYI/Xd9TjHMsVE+spRbI33lJYUmW1U0QS9gysUP5W4+6wDW2HLjnVNAQT4=
Message-ID: <46A47932.8000709@googlemail.com>
Date: Mon, 23 Jul 2007 11:47:30 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Markus <lists4me@web.de>,
       Andre Noll <maan@systemlinux.org>, acpi4asus-user@lists.sourceforge.net,
       Corentin Chary <corentincj@iksaif.net>,
       Karol Kozimor <sziwan@users.sourceforge.net>,
       Gabriel C <nix.or.die@googlemail.com>, Netdev <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@osdl.org>, Thomas Meyer <thomas@m3y3r.de>
Subject: [1/2] 2.6.23-rc1: known regressions
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc1.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Andi Kleen                             4
Linus Torvalds                         4
Adrian Bunk                            3
Andrew Morton                          3
Jens Axboe                             3
Al Viro                                2
David Woodhouse                        2
Hugh Dickins                           2
Tejun Heo                              2



Unclassified

Subject         : /usr/bin/ld: section .text [ffffffffff700500 -> ffffffffff7007e3] overlaps section .gnu.version_d [ffffffffff7004d8 -> ffffffffff70050f]
References      : http://lkml.org/lkml/2007/7/22/239
Last known good : ?
Submitter       : Andre Noll <maan@systemlinux.org>
Caused-By       : ?
Handled-By      : Andi Kleen <ak@suse.de>
Status          : problem is being debugged

Subject         : pcwd_init_module(): WARNING: at lib/kref.c:33 kref_get()
References      : http://lkml.org/lkml/2007/7/22/94
Last known good : ?
Submitter       : Ingo Molnar <mingo@elte.hu>
Caused-By       : ?
Handled-By      : ?
Status          : problem is being debugged

Subject         : konqueror suddenly vanishing, "konqueror: Fatal IO error: client killed"
References      : http://lkml.org/lkml/2007/7/22/86
Last known good : ?
Submitter       : Markus <lists4me@web.de>
Caused-By       : ?
Handled-By      : Ingo Molnar <mingo@elte.hu>
Status          : problem is being debugged



ACPI

Subject         : drivers/misc/asus-laptop.c:*: error: 'struct led_classdev' has no member named 'class_dev'
References      : http://lkml.org/lkml/2007/7/22/299
Last known good : ?
Submitter       : Gabriel C <nix.or.die@googlemail.com>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Networking

Subject         : New wake ups from sky2
References      : http://lkml.org/lkml/2007/7/20/386
Last known good : ?
Submitter       : Thomas Meyer <thomas@m3y3r.de>
Caused-By       : Stephen Hemminger <shemminger@osdl.org>
                  commit eb35cf60e462491249166182e3e755d3d5d91a28
Handled-By      : Stephen Hemminger <shemminger@osdl.org>
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
