Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbXGWJu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbXGWJu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 05:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760957AbXGWJtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 05:49:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:13353 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760541AbXGWJtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 05:49:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=moNNh/XGPx+ZXWyzIxTBEyQNgqAt1+Njn8r0EAqAJeZuXEfwwrz/cjA5XnOs5eooBuPWMfGzYOWF2/2tnLXtSRWA1pOw7MVxL4Wt7r94IrxUafkIvjNXlawWHNW02JqHj+Fm0+v3aQGkhW/MVIh4NvLP8wlmr2m55xf6io+3xyE=
Message-ID: <46A47940.7030801@googlemail.com>
Date: Mon, 23 Jul 2007 11:47:44 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Satyam Sharma <satyam.sharma@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>, Takashi Iwai <tiwai@suse.de>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       Doug Chapman <doug.chapman@hp.com>, Vasily Tarasov <vtaras@openvz.org>,
       Thierry MERLE <thierry.merle@free.fr>, v4l-dvb-maintainer@linuxtv.org,
       "Dwaine P. Garden" <dwainegarden@rogers.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: 2.6.23-rc1: known regressions with patches
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc1
with patches available.

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

Subject         : Regression with sys_time() speedup patch
References      : http://lkml.org/lkml/2007/7/20/205
Last known good : ?
Submitter       : Takashi Iwai <tiwai@suse.de>
Caused-By       : ?
Handled-By      : Ingo Molnar <mingo@elte.hu>
Patch           : http://lkml.org/lkml/2007/7/20/219
Status          : patch available

Subject         : kobject link failure
References      : http://lkml.org/lkml/2007/7/19/495
Last known good : ?
Submitter       : Jan Engelhardt <jengelh@linux01.gwdg.de>
Caused-By       : ?
Handled-By      : Cornelia Huck <cornelia.huck@de.ibm.com>
                  Greg Kroah-Hartman <gregkh@suse.de>
Patch           : http://lkml.org/lkml/2007/7/20/143
Status          : patch available

Subject         : Kconfig prompts without help text
References      : http://lkml.org/lkml/2007/7/16/326
Last known good : ?
Submitter       : Stefan Richter <stefanr@s5r6.in-berlin.de>
Caused-By       : ?
Handled-By      : Jan Engelhardt <jengelh@linux01.gwdg.de>
Patch           : http://lkml.org/lkml/2007/7/18/236
Status          : patch available

Subject         : Oops while modprobing phy fixed module
References      : http://lkml.org/lkml/2007/7/14/63
Last known good : ?
Submitter       : Gabriel C <nix.or.die@googlemail.com>
Caused-By       : Tejun Heo <htejun@gmail.com>
                  commit 3007e997de91ec59af39a3f9c91595b31ae6e08b
Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
                  Tejun Heo <htejun@gmail.com>
                  Vitaly Bordug <vitb@kernel.crashing.org>
Patch1          : http://lkml.org/lkml/2007/7/18/506
Status          : patch available



FS

Subject         : ia64 build failure from recent diskquota patch
References      : http://lkml.org/lkml/2007/7/18/407
Last known good : ?
Submitter       : Doug Chapman <doug.chapman@hp.com>
Caused-By       : Vasily Tarasov <vtaras@openvz.org>
                  commit b716395e2b8e450e294537de0c91476ded2f0395
Handled-By      : Luck, Tony <tony.luck@intel.com>
Patch1          : http://lkml.org/lkml/2007/7/20/255
Patch2          : http://lkml.org/lkml/2007/7/20/272
Status          : patch available



Media

Subject         : usbvision: don't return an uninitialized value
References      : http://lkml.org/lkml/2007/7/23/65
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : ?
Handled-By      : Adrian Bunk <bunk@stusta.de>
Patch           : http://lkml.org/lkml/2007/7/23/65
Status          : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
