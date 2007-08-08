Return-Path: <linux-kernel-owner+w=401wt.eu-S937224AbXHHROs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937224AbXHHROs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936939AbXHHRNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:13:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:6567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbXHHRNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:13:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=stOmz7lzDEvEMcBKrGtc8iVZKmVpLL/2esNVxjtu9PJ5TP6iC/O82Q8iQJXAPyXuZU6v+IcBTJohQ+FIpTow7daJoXB5kBPHUO4+YU+5rhO0nkbO6sdoEZRYFPZDKhcFQ2vYFktl4H8g1vUGbjs5KQucN3UNSNaDfB289GArthg=
Message-ID: <46B9F99A.7050601@googlemail.com>
Date: Wed, 08 Aug 2007 19:12:58 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       Eric Sesterhenn <snakebyte@gmx.de>,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Hugh Dickins <hugh@veritas.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [2/2] 2.6.23-rc2: known regressions with patches v2
References: <46B9F8D4.9090605@googlemail.com>
In-Reply-To: <46B9F8D4.9090605@googlemail.com>
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
Peter Zijlstra                         2
Trent Piepho                           2



ACPI

Subject         : [2.6.23 regression fix] fix thinkpad_acpi without hardware
References      : http://lkml.org/lkml/2007/8/5/184
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : Henrique de Moraes Holschuh <hmh@hmh.eng.br>
                  commit d5a2f2f1d68e2da538ac28540cddd9ccc733b001
Handled-By      : Adrian Bunk <bunk@stusta.de>
Patch           : http://thread.gmane.org/gmane.linux.acpi.devel/24413
Status          : patch available

Subject         : T60 ACPI issues/THINKPAD_ACPI_INPUT_ENABLED seems regressive
References      : http://lkml.org/lkml/2007/8/1/198
                  http://lkml.org/lkml/2007/8/1/176
Last known good : ?
Submitter       : Michael S. Tsirkin <mst@dev.mellanox.co.il>
                  Hugh Dickins <hugh@veritas.com>
Caused-By       : Henrique de Moraes Holschuh <hmh@hmh.eng.br>
                  commit 1a343760b516ca5466d201bec32b1794858b18a5
Handled-By      : Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Patch           : http://thread.gmane.org/gmane.linux.acpi.devel/24646
Status          : patch available

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



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
