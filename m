Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbYDAOI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbYDAOI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 10:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbYDAOIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 10:08:51 -0400
Received: from smtp.nokia.com ([192.100.105.134]:16533 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbYDAOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 10:08:50 -0400
Message-ID: <47F240F6.3080108@nokia.com>
Date: Tue, 01 Apr 2008 17:04:38 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Artem Bityutskiy <dedekind@yandex.ru>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [RFC PATCH 20/26] UBIFS: add VFS operations
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>	 <1206629746-4298-21-git-send-email-Artem.Bityutskiy@nokia.com>	 <84144f020804010508k3099b2bagf2f1c0d2747a983@mail.gmail.com>	 <47F22DD3.4060003@yandex.ru> <84144f020804010612iec1c2d9xc9096f8cc3cd9d4d@mail.gmail.com>
In-Reply-To: <84144f020804010612iec1c2d9xc9096f8cc3cd9d4d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 14:08:31.0437 (UTC) FILETIME=[DDA2C7D0:01C89401]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
>>  Yeah, this is also a guarding thing. When a dirty page is released
>>  the budget which was allocated for it has to be freed. If this function
>>  is called, then the budget was not freed, which must never happen.
> 
> So what guarantees that no one calls invalidate_complete_page() or
> fallback_migrate_page(), for example?

At the first glance it looks like it might be called, but for clean pages,
which is not the problem, but there is this assert which may give fake
alarm. Need to look closer at this. Thanks for the note.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
