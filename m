Return-Path: <linux-kernel-owner+w=401wt.eu-S1751655Ab0ANFMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab0ANFMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431Ab0ANFMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:12:31 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45029 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab0ANFM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:12:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UuFBIwFt4G2vZMVYmvZ5x5xYN3IpbkHYHFYIuaQ8mXmJeTbTC6yUPk95SQd9xE3nB3
         yqs8Y3ND9DXdZtFLcP0sAVEccHEVlhbLKWw7E4TzQoc95d60XLX8KReyYe/2LPJVNWrB
         giEI+IbYEt26gTxLkeZREI2PWPehi8k/hUpcc=
MIME-Version: 1.0
In-Reply-To: <20100114084659.D713.A69D9226@jp.fujitsu.com>
References: <20100113171953.B3E5.A69D9226@jp.fujitsu.com>
	 <28c262361001130231k29b933der4022f4d1da80b084@mail.gmail.com>
	 <20100114084659.D713.A69D9226@jp.fujitsu.com>
Date: Thu, 14 Jan 2010 14:12:25 +0900
Message-ID: <28c262361001132112i7f50fd66qcd24dc2ddb4d78d8@mail.gmail.com>
Subject: Re: [PATCH 2/3][v2] vmstat: add anon_scan_ratio field to zoneinfo
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 8:50 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
>> Hi, Kosaki.
>>
>> On Wed, Jan 13, 2010 at 5:21 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > Changelog
>> >  from v1
>> >  - get_anon_scan_ratio don't tak zone->lru_lock anymore
>> >   because zoneinfo_show_print takes zone->lock.
>>
>> When I saw this changelog first, I got confused.
>> That's because there is no relation between lru_lock and lock in zone.
>> You mean zoneinfo is allowed to have a stale data?
>> Tend to agree with it.
>
> Well. zone->lock and zone->lru_lock should be not taked at the same time.

I looked over the code since I am out of office.
I can't find any locking problem zone->lock and zone->lru_lock.
Do you know any locking order problem?
Could you explain it with call graph if you don't mind?

I am out of office by tomorrow so I can't reply quickly.
Sorry for late reponse.


-- 
Kind regards,
Minchan Kim
