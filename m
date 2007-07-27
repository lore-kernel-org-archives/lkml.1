Return-Path: <linux-kernel-owner+w=401wt.eu-S937891AbXG0U4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937891AbXG0U4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935397AbXG0Uz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:55:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:19649 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764313AbXG0Uzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:55:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=gMxQxac6+uOWH/JFNdAYEXNEvRNOm+E4l9Mv2iHW0jQGdSZz6yqv/o5C5qAietkftXxTKqRrgcFV6GZX+crcsVzu3NUDuVcnQ/AgtiRer9ZB8ZqaC6qXwDtxOLFe0M90nwzfj0iqMqdvmQQb6u1mPdhDzjXhzx2H2av9E4i5kjA=
Message-ID: <46AA5B31.4090909@googlemail.com>
Date: Fri, 27 Jul 2007 22:53:05 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Markus <lists4me@web.de>, Andre Noll <maan@systemlinux.org>,
       Wim Van Sebroeck <wim@iguana.be>, Borislav Petkov <bbpetkov@yahoo.de>,
       Bret Towe <magnade@gmail.com>, Nick Piggin <npiggin@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jakub Jelinek <jakub@redhat.com>
Subject: [1/3] 2.6.23-rc1: known regressions v2
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
Adrian Bunk                            6
Andi Kleen                             4
Andrew Morton                          4
Linus Torvalds                         4
Al Viro                                3
Jens Axboe                             3
Tejun Heo                              3
David Woodhouse                        2
Hugh Dickins                           2



Unclassified

Subject         : 2.6.23-rc1 regression: mm: fix fault vs invalidate race for linear mappings
References      : http://lkml.org/lkml/2007/7/24/301
Last known good : ?
Submitter       : Bret Towe <magnade@gmail.com>
Caused-By       : Nick Piggin <npiggin@suse.de>
                  commit d00806b183152af6d24f46f0c33f14162ca1262a
Handled-By      : ?
Status          : unknown

Subject         : no setup signature found...
References      : http://lkml.org/lkml/2007/7/24/168
Last known good : ?
Submitter       : Borislav Petkov <bbpetkov@yahoo.de>
Caused-By       : H. Peter Anvin <hpa@zytor.com>
                  commit 4fd06960f120e02e9abc802a09f9511c400042a5
Handled-By      : H. Peter Anvin <hpa@zytor.com>
Status          : problem is being debugged

Subject         : /usr/bin/ld: section .text [ffffffffff700500 -> ffffffffff7007e3] overlaps section .gnu.version_d [ffffffffff7004d8 -> ffffffffff70050f]
References      : http://lkml.org/lkml/2007/7/22/239
Last known good : ?
Submitter       : Andre Noll <maan@systemlinux.org>
Caused-By       : ?
Handled-By      : Andi Kleen <ak@suse.de>
                  Jakub Jelinek <jakub@redhat.com>
Status          : problem is being debugged

Subject         : pcwd_init_module(): WARNING: at lib/kref.c:33 kref_get()
References      : http://lkml.org/lkml/2007/7/22/94
Last known good : ?
Submitter       : Ingo Molnar <mingo@elte.hu>
Caused-By       : ?
Handled-By      : Wim Van Sebroeck <wim@iguana.be>
Status          : problem is being debugged

Subject         : konqueror suddenly vanishing, "konqueror: Fatal IO error: client killed"
References      : http://lkml.org/lkml/2007/7/22/86
Last known good : ?
Submitter       : Markus <lists4me@web.de>
Caused-By       : ?
Handled-By      : Ingo Molnar <mingo@elte.hu>
Status          : problem is being debugged



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

