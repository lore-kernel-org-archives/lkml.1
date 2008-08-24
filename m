Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbYHXQck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbYHXQck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 12:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYHXQcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 12:32:31 -0400
Received: from ns2.suse.de ([195.135.220.15]:41820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbYHXQca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 12:32:30 -0400
From: Andreas Schwab <schwab@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: Help with compiler warning
References: <48AE1802.5090301@lwfinger.net> <48B17E56.3060106@panasas.com>
	<48B17EE0.2090608@panasas.com> <48B18361.6000305@lwfinger.net>
X-Yow: I am a jelly donut.  I am a jelly donut.
Date: Sun, 24 Aug 2008 18:32:26 +0200
In-Reply-To: <48B18361.6000305@lwfinger.net> (Larry Finger's message of "Sun,
	24 Aug 2008 10:50:57 -0500")
Message-ID: <jemyj29xwl.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> Benny Halevy wrote:
>> On Aug. 24, 2008, 18:29 +0300, Benny Halevy <bhalevy@panasas.com> wrote:
>>> On Aug. 22, 2008, 4:36 +0300, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>>> In drivers/pcmcia/cardbus.c, the following statement
>>>>
>>>>          memcpy_fromio(ptr, s->cb_cis_virt + addr, len);
>>>>
>>>> generates the warning
>>>>
>>>>    CC [M]  drivers/pcmcia/cardbus.o
>>>> include/asm/io_32.h: In function ‘memcpy_fromio’:
>>>> include/asm/io_32.h:151: warning: passing argument 2 of ‘__memcpy’
>>>> discards qualifiers from pointer target type
>>>>
>>>> s->cb_cis_virt is "void __iomem" and addr is uint.
>>>>
>>>> What cast does argument 2 need to silence the warning?

The cast needs to be in memcpy_fromio, but there is already one, so why
do you get a warning in the first place?

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
