Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbXK1FTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbXK1FTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 00:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbXK1FTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 00:19:34 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:56494 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842AbXK1FTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 00:19:34 -0500
Message-ID: <474CFA64.8050608@lwfinger.net>
Date: Tue, 27 Nov 2007 23:19:32 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding mutex locking
References: <fa.C9TdvYAhY8SablNc39IpD8WDnNM@ifi.uio.no> <474CF440.2000001@shaw.ca>
In-Reply-To: <474CF440.2000001@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Larry Finger wrote:
>> If a particular routine needs to lock a mutex, but it may be entered
>> with that mutex already locked,
>> would the following code be SMP safe?
>>
>> hold_lock = mutex_trylock()
>>
>> ..
>>
>> if (hold_lock)
>>     mutex_unlock()
> 
> Not if another task could be acquiring that lock at the same time, which
> is probably the case, otherwise you wouldn't need the mutex. In other
> words, if you're going to do this, you might as well toss the mutex
> entirely as it's about the same effect..
> 

Thanks for the help. Someday, I hope to understand this stuff.

Larry

