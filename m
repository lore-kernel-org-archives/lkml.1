Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbXHEQ2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbXHEQ2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 12:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbXHEQ2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 12:28:03 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:37722 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbXHEQ16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 12:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=GySPPr93NjgBHpbWsGhSN/AHQ+oxiYNjiZHqFk9hFIpauWXP25lyMimS4F2JVkch63K8nNhxiwHyihvjRkAYNVFkRIrxNUii9Gdku5Og9Z66Sy/w+RvO9GLele4bru4BW0O9zB6rDfjfJt2F493XQQ6n1nQ99bZLeAgjp0Nnvoc=
Message-ID: <46B5FA43.9010809@googlemail.com>
Date: Sun, 05 Aug 2007 18:26:43 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>, Adrian Bunk <bunk@stusta.de>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       Eric Sesterhenn <snakebyte@gmx.de>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Jeff Garzik <jeff@garzik.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [1/2] 2.6.23-rc2: known regressions with patches
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc2
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            6
Andi Kleen                             4
Andrew Morton                          4
Linus Torvalds                         4
Al Viro                                3
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3
David Woodhouse                        2
Hugh Dickins                           2
Trent Piepho                           2



Unclassified

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
Caused-By       : ?
Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
                  Vitaly Bordug <vitb@kernel.crashing.org>
Patch1          : http://lkml.org/lkml/2007/7/18/506
Status          : patch available



ACPI

Subject         : acpi_ec_remove() use-after-free
References      : http://lkml.org/lkml/2007/7/29/138
Last known good : 2.6.22
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : Alexey Starikovskiy <astarikovskiy@suse.de>
                  commit 837012ede14a8fc088be3682c964da7fc6af026b
Handled-By      : Adrian Bunk <bunk@stusta.de>
Patch           : http://lkml.org/lkml/2007/7/29/138
Status          : patch available

Subject         : Time Problems with 2.6.23-rc1-gf695baf2
References      : http://lkml.org/lkml/2007/7/23/486
Last known good : ?
Submitter       : Eric Sesterhenn <snakebyte@gmx.de>
Caused-By       : Venki Pallipadi <venkatesh.pallipadi@intel.com>
                  commit 18eab8550397f1f3d4b8b2c5257c88dae25d58ed
Handled-By      : ?
Patch           : http://marc.info/?l=linux-kernel&m=118590919604954&w=2
Status          : patch available



FS

Subject         : NFSv4 poops itself
References      : http://lkml.org/lkml/2007/7/27/144
Last known good : ?
Submitter       : Jeff Garzik <jeff@garzik.org> 
Caused-By       : ?
Handled-By      : Trond Myklebust <Trond.Myklebust@netapp.com>
Patch           : http://lkml.org/lkml/2007/7/27/183
Status          : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
