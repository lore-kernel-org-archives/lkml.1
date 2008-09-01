Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbYIAMAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbYIAMAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 08:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYIAMAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 08:00:45 -0400
Received: from smtp.nokia.com ([192.100.122.233]:40148 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbYIAMAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 08:00:45 -0400
Message-ID: <48BBD875.40705@yandex.ru>
Date: Mon, 01 Sep 2008 14:56:37 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: dedekind@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH] UBIFS: fill f_fsid
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>	 <1220194366-12731-13-git-send-email-dedekind@infradead.org>	 <1220262187.2982.58.camel@pmac.infradead.org>	 <1220267810.4036.24.camel@sauron>	 <1220268480.2982.68.camel@pmac.infradead.org>	 <1220269436.4036.29.camel@sauron> <1220269804.2982.72.camel@pmac.infradead.org>
In-Reply-To: <1220269804.2982.72.camel@pmac.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Sep 2008 12:00:02.0327 (UTC) FILETIME=[43D9B270:01C90C2A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Mon, 2008-09-01 at 14:43 +0300, Artem Bityutskiy wrote:
>> May be, but there are only 5 bytes left. 
> 
> There are 5 uint32_ts left. And then there would be 3.
O, right.

> But there's no overriding reason to do it, really.
Yeah, I would not go for it unless there is a specific problem
which should be solved with this.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
