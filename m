Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbYDAMBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbYDAMBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 08:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYDAMAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 08:00:53 -0400
Received: from smtp.nokia.com ([192.100.122.230]:44017 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYDAMAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:00:51 -0400
Message-ID: <47F22302.6020308@nokia.com>
Date: Tue, 01 Apr 2008 14:56:50 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Artem Bityutskiy <dedekind@yandex.ru>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>	 <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com>	 <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com>	 <47F1F7A6.5020105@yandex.ru>	 <84144f020804010215o209fbed8gf629dc6557fcd091@mail.gmail.com>	 <47F1FF98.9020809@nokia.com>	 <84144f020804010304w7057a68cqa5b9a7a5364b9489@mail.gmail.com>	 <47F20DEE.7090105@nokia.com> <84144f020804010433xafc6f28o5a5375ce82903a7a@mail.gmail.com>
In-Reply-To: <84144f020804010433xafc6f28o5a5375ce82903a7a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 12:00:42.0910 (UTC) FILETIME=[02D66BE0:01C893F0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Tue, Apr 1, 2008 at 1:26 PM, Artem Bityutskiy
>         ubifs_assert(PageLocked(page));
>         ubifs_assert(!PageChecked(page));
>         ubifs_assert(!PagePrivate(page));
> 
> So instead of arguing about this you really ought to look at what
> SLUB, for example, does. It's perfectly okay to have _debugging
> checks_ compiled out (stuff like verify_inode and such) but at the
> assertion level it makes no sense whatsoever!

This was more for developing. I added that to be really sure those
requirements are met. As I said, the amount of assertions will be
lessened and these ones will be deleted. There are other assertions
in the VFS calls implementation functions, which also will be deleted.

I'll look at the SLUB.

>> UBIFS DBG (pid 28398): ubifs_create: dent 'file', mode 0x81a4 in dir ino 1
>> or
>> UBIFS DBG (pid 28398): ubifs_setattr: ino 65, ia_valid 0x70
> 
> So what? It's still an ad hoc debugging printout with no particular
> meaning whatsoever.

You still do not explain what is wrong with this. For me it means that
ubifs_setattr() was called for inode 65. And when I debugging a bug I
know what's going on.

> But this discussion is getting nowhere and I have better things to do
> than argue about this over and over again.
Fair enough. As I said, we will review debugging and lessen the amount of
it.

Thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
