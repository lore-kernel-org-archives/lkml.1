Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbXH2P35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbXH2P35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 11:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758974AbXH2P3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 11:29:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:62735 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbXH2P3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 11:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=bQkxBA256wcXbHebB6JUNc60zHdCHJHgDCUhojBJeDqYCwp2GGkvNluTQnR3Exj8quUEPRVEEt3Rk4yuhnB9nE325A+7ZWi+NDkCzx3c86RVix0XZHVCsUQvJlunpraEjGHHqW+uz6f7EPuCy1iUpV5OrqoOJ0xTu1bL/GTrsaY=
Message-ID: <46D59099.8000709@googlemail.com>
Date: Wed, 29 Aug 2007 17:28:25 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Trond Myklebust <Trond.Myklebust@netapp.com>,
       Florin Iucha <florin@iucha.net>, Bret Towe <magnade@gmail.com>,
       Harry Edmon <harry@atmos.washington.edu>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Christian Casteyde <casteyde.christian@free.fr>,
       Alan Stern <stern@rowland.harvard.edu>, linux-mtd@lists.infradead.org,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Netdev <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@osdl.org>,
       Florian Lohoff <flo@rfc822.org>, "Daniel K." <daniel@cluded.net>
Subject: Re: [2/2] 2.6.23-rc3: known regressions with patches
References: <46D58F89.4010108@googlemail.com>
In-Reply-To: <46D58F89.4010108@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc4
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            9
Andi Kleen                             5
Linus Torvalds                         5
Andrew Morton                          4
Hugh Dickins                           4
Al Viro                                3
Alan Stern                             3
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3



FS

Subject         : NFSv4 client OOPS
References      : http://lkml.org/lkml/2007/8/28/207
Last known good : ?
Submitter       : Harry Edmon <harry@atmos.washington.edu>
Caused-By       : ?
Handled-By      : Trond Myklebust <Trond.Myklebust@netapp.com>
Patch           : http://lkml.org/lkml/2007/8/28/204
Status          : patch available

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
Handled-By      : Trond Myklebust <Trond.Myklebust@netapp.com>
Patch           : http://lkml.org/lkml/2007/8/28/119
Status          : patch available



MMC

Subject         : Unable to access memory card reader anymore
References      : http://bugzilla.kernel.org/show_bug.cgi?id=8885
Last known good : ?
Submitter       : Christian Casteyde <casteyde.christian@free.fr>
Caused-By       : ?
Handled-By      : Alan Stern <stern@rowland.harvard.edu>
Patch           : http://bugzilla.kernel.org/attachment.cgi?id=12438
Status          : patch available



MTD

Subject         : error: implicit declaration of function 'cfi_interleave'
References      : http://lkml.org/lkml/2007/8/6/272
Last known good : ?
Submitter       : Ingo Molnar <mingo@elte.hu>
Caused-By       : ?
Handled-By      : David Woodhouse <dwmw2@infradead.org>
Patch           : http://lkml.org/lkml/2007/8/9/586
Status          : patch available



Networking

Subject         : BUG: when using 'brctl stp'
References      : http://lkml.org/lkml/2007/8/10/441
Last known good : 2.6.23-rc1
Submitter       : Daniel K. <daniel@cluded.net>
Caused-By       : ?
Handled-By      : Stephen Hemminger <shemminger@osdl.org>
Status          : fix applied by David Miller

Subject         : sky2 boot crash in sky2_mac_intr
References      : http://lkml.org/lkml/2007/7/24/91
Last known good : ?
Submitter       : Florian Lohoff <flo@rfc822.org>
Caused-By       : 
Handled-By      : Stephen Hemminger <shemminger@osdl.org>
Patch           : http://marc.info/?l=linux-netdev&m=118651402523966&w=2
Status          : patch available



Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
