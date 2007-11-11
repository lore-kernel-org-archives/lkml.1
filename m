Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbXKKVFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbXKKVFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 16:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXKKVFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 16:05:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbXKKVFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 16:05:21 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
To: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mundt <lethal@linux-sh.org>, Jeff Garzik <jeff@garzik.org>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Reply-To: 7eggert@gmx.de
Date: Sun, 11 Nov 2007 22:03:58 +0100
References: <9nL9f-2n8-11@gated-at.bofh.it> <9nPcU-bm-3@gated-at.bofh.it> <9nTqh-6Cw-7@gated-at.bofh.it> <9nTTh-7w5-7@gated-at.bofh.it> <9nTTh-7w5-5@gated-at.bofh.it> <9nUcv-7UA-7@gated-at.bofh.it> <9o5hA-b8-7@gated-at.bofh.it> <9o640-1rJ-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1IrJyI-0003aj-Bm@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18QhKK2vb6m4A4ayN/QfWAT/uhffbIEDJrNv6M
 wE4wCWDEMZp3vuheX6+FCjDBeSjp+GYLyT7wWTzWz8FZKwZ/xR
 58BbQvVhrtuB918vmdISw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> wrote:
> On Sat, Nov 10, 2007 at 12:35:01PM -0800, H. Peter Anvin wrote:

>> In fact, we should be able to get rid of ARCH entirely;  CONFIG_ options
>> have the huge advantage that they're saved in a file, and you don't have to
>> type them on every make run. The only option that I can't see us getting
>> rid of easily is HOSTCC, since it is used before config is run, but
>> probably something clever can be done there, too.

> Yes, please!  One of the more annoying things is forgetting the
> ARCH=um when rebuilding UML.  It would be awfully nice if ARCH was set
> via a CONFIG_ option and was persistent.

This should have been fixed, or it's about to be fixed. My patch is here:
http://groups.google.com/group/linux.kernel/browse_thread/thread/93e5c33fc6e8cff6/39aff558a636ad02
(This patch was superseded by another patch, which may be delayed or mm-only.)

OTOH, if you can implement ARCH= using CONFIG_ARCH, why not? Just don't forget
to keep the scripts running, and make randconfig only select buildable archs.


