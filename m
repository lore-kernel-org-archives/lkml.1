Return-Path: <linux-kernel-owner+w=401wt.eu-S933622AbYEFXHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbYEFXHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759271AbYEFXG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:06:57 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:39862 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYEFXGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:06:55 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Willy Tarreau <w@1wt.eu>
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: bad pmd ffff810000207808(9090909090909090).
References: <874p9biqwj.fsf@duaron.myhome.or.jp>
	<alpine.LNX.1.10.0805061424090.16731@fbirervta.pbzchgretzou.qr>
	<87zlr3zj9x.fsf@duaron.myhome.or.jp> <20080506195014.GS8474@1wt.eu>
Date: Wed, 07 May 2008 08:06:47 +0900
In-Reply-To: <20080506195014.GS8474@1wt.eu> (Willy Tarreau's message of "Tue,
	6 May 2008 21:50:15 +0200")
Message-ID: <87abj3nibc.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w@1wt.eu> writes:

>> I see. I'm not sure, but I didn't notice this soon, maybe it worked as
>> almost usual.
>
> I got immediate same feeling as Jan here. It looks very much like someone
> has tried to inject code into your system. The problem is that you don't
> know if this finally succeeded. Maybe some backdoor is now installed in
> your kernel. If I were you, I would isolate the machine, reboot it on CD
> and check MD5s (particularly the ones of the kernel and modules) before
> rebooting it.

Hm.. I've checked md5sum as far as I can do (/var/lib/dpkg/info/*.md5sums).
It seems to have no difference except data files.

And this machine is in back of firewall of other machine, and the kernel
is builded from source each every day or a hour or such.

So, it is unlikely...

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
