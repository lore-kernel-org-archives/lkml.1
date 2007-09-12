Return-Path: <linux-kernel-owner+w=401wt.eu-S970387AbXILRCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970387AbXILRCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970034AbXILRAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:00:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:9283 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934904AbXILRAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:00:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=WIL2b9RJrj710ucALatCnPaQf89dQ3DKI5WiV8Z3EX0IlvS3wcm1DIX9tTSXZLtgUu8pMsNBrAsxTjm2aaSNQ+qTRNpw6SVQBugucV6q6bYeUntQQKh++mP5k93kXKXIYOpNV9TdsM8cLGpoZUFA8IEGSk8rcOV9x7YYo/bwVG8=
Message-ID: <46E81AE2.8030802@googlemail.com>
Date: Wed, 12 Sep 2007 18:59:14 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <gregkh@suse.de>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       =?ISO-8859-2?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       netdev@vger.kernel.org, Christian Kujau <lists@nerdbynature.de>,
       jamal <hadi@cyberus.ca>, linux-usb-devel@lists.sourceforge.net,
       Greg KH <gregkh@suse.de>,
       =?ISO-8859-2?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       sean@mess.org, Adrian Bunk <bunk@kernel.org>
Subject: 2.6.23-rc6: known regressions with patches
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc6
with patches available.

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



Unclassified

Subject         : Oops while modprobing phy fixed module
References      : http://lkml.org/lkml/2007/7/14/63
Last known good : ?
Submitter       : Gabriel C <nix.or.die@googlemail.com>
Caused-By       : ?
Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
                  Vitaly Bordug <vitb@kernel.crashing.org>
Patch1          : http://lkml.org/lkml/2007/7/18/506
Status          : patch available



Drivercore

Subject         : sysfs change of input/event devices in 2.6.23rc breaks udev
References      : http://lkml.org/lkml/2007/9/8/86
Last known good : ?
Submitter       : Anssi Hannula <anssi.hannula@gmail.com>
Caused-By       : ?
Handled-By      : Dmitry Torokhov <dmitry.torokhov@gmail.com>
Patch           : http://lkml.org/lkml/2007/9/10/3
Status          : patch available



MTD

Subject         : include/linux/mtd/map.h:128:2: error: #error "No bus width supported. What's the point?"
References      : http://lkml.org/lkml/2007/9/11/151
Last known good : ?
Submitter       : Toralf Förster <toralf.foerster@gmx.de>
Caused-By       : ?
Handled-By      : ?
Patch           : http://git.infradead.org/?p=mtd-2.6.git;a=commit;h=241651d04d672fb685b2874707016cbbf95931e5
Status          : patch available



Networking

Subject         : 2.6.23-rc5: possible irq lock inversion dependency detected
References      : http://lkml.org/lkml/2007/9/2/97
Last known good : ?
Submitter       : Christian Kujau <lists@nerdbynature.de>
Caused-By       : ?
Handled-By      : jamal <hadi@cyberus.ca>
Patch           : http://lkml.org/lkml/2007/9/11/159
Status          : patch available



USB

Subject         : build #246 failed for 2.6.23-rc6-g0d4cbb5 in linux/drivers/usb/misc/phidgetservo.ko
References      : http://lkml.org/lkml/2007/9/11/211
Last known good : ?
Submitter       : Toralf Förster <toralf.foerster@gmx.de>
Caused-By       : ?
Handled-By      : Adrian Bunk <bunk@kernel.org>
Patch           : http://lkml.org/lkml/2007/9/11/284
Status          : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
