Return-Path: <linux-kernel-owner+w=401wt.eu-S940027AbXGSQgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940027AbXGSQgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940001AbXGSQgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:36:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:53060 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939942AbXGSQgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:36:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=gdZum4r3ik/5BpE/2mt/ibDQUrSXwbyyQSnQ82cyBeJ596QQRq+2lsKEYwyP/0IbbRPh6CC8QCvdjkhZL80UHWUTnobxC76x/F2Za27bAPtPg+93sTQeg9O1i3KKrlbyZWzXj5i6h7z22juZem/RC3fx06EXM5L1SDW+Xxv1L4I=
Message-ID: <469F92AF.10405@googlemail.com>
Date: Thu, 19 Jul 2007 18:34:55 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       Mingming Cao <cmm@us.ibm.com>, Doug Chapman <doug.chapman@hp.com>,
       Vasily Tarasov <vtaras@openvz.org>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [2/2] 2.6.22-git: known regressions
References: <469F9125.8040502@googlemail.com>
In-Reply-To: <469F9125.8040502@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-git.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            3
Andi Kleen                             2
Andrew Morton                          2
David Woodhouse                        2
Hugh Dickins                           2
Jens Axboe                             2



FS

Subject         : ia64 build failure from recent diskquota patch
References      : http://lkml.org/lkml/2007/7/18/407
Last known good : ?
Submitter       : Doug Chapman <doug.chapman@hp.com>
Caused-By       : Vasily Tarasov <vtaras@openvz.org>
                  commit b716395e2b8e450e294537de0c91476ded2f0395
Handled-By      : ?
Status          : unknown

Subject         : ext4 build warnings
References      : http://lkml.org/lkml/2007/7/18/420
Last known good : ?
Submitter       : Jeff Garzik <jeff@garzik.org>
Caused-By       : ?
Handled-By      : Mingming Cao <cmm@us.ibm.com>
Status          : unknown



IDE

Subject         : compile error if CONFIG_BLOCK not enabled related to linux/ide.h include
References      : http://lkml.org/lkml/2007/7/18/11
Last known good : ?
Submitter       : Kumar Gala <galak@kernel.crashing.org>
Caused-By       : ?
Handled-By      : Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Status          : unknown



Memory management

Subject         : kmalloc zero size changes break i386
References      : http://lkml.org/lkml/2007/7/19/172
Last known good : ?
Submitter       : Andi Kleen <ak@suse.de>
Caused-By       : Christoph Lameter <clameter@sgi.com>
                  commit 6cb8f91320d3e720351c21741da795fed580b21b
Handled-By      : ?
Status          : unknown



SYSFS

Subject         : sysfs root link count broken in 2.6.22-git5
References      : http://lkml.org/lkml/2007/7/15/62
Last known good : ?
Submitter       : Jean Delvare <khali@linux-fr.org>
Caused-By       : ?
Handled-By      : Tejun Heo <htejun@gmail.com>
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
