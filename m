Return-Path: <linux-kernel-owner+w=401wt.eu-S966795AbXG3QeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966795AbXG3QeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764063AbXG3Qd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:33:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:6001 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760864AbXG3Qd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:33:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ja5IdCse43XngF/6FGV2a4dqfuugMYUfyaLwrLVyCk7Ss7/5FVIjz6h54CjFz5MJ5BuD/vH/fCG+h9d950T2mbFr57NtUSN2Sclb+vvgKrYoggsveBc6/bs3Sy9MbFbMW/KLOdQ6s2miqlfnuUHXEdWmawOXGYi/ficKvhOv0rA=
Message-ID: <46AE12EE.1070501@googlemail.com>
Date: Mon, 30 Jul 2007 18:33:50 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andre Noll <maan@systemlinux.org>,
       Wim Van Sebroeck <wim@iguana.be>, Borislav Petkov <bbpetkov@yahoo.de>,
       Bret Towe <magnade@gmail.com>, Nick Piggin <npiggin@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jakub Jelinek <jakub@redhat.com>,
       Eric Sesterhenn <snakebyte@gmx.de>, Sid Boyce <g3vbv@blueyonder.co.uk>
Subject: [1/3] 2.6.23-rc1: known regressions v3
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

Subject         : 2.6.23-rc1-git3 init failure
References      : http://lkml.org/lkml/2007/7/26/467
Last known good : 2.6.23-rc1-git1
Submitter       : Sid Boyce <g3vbv@blueyonder.co.uk>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : Time Problems with 2.6.23-rc1-gf695baf2
References      : http://lkml.org/lkml/2007/7/23/486
Last known good : ?
Submitter       : Eric Sesterhenn <snakebyte@gmx.de>
Caused-By       : ?
Handled-By      : ?
Status          : problem is being debugged

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



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
