Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbXK1Plc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbXK1Plc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbXK1PlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:41:24 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:37531 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754717AbXK1PlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:41:24 -0500
Message-ID: <474D8C22.7010902@lwfinger.net>
Date: Wed, 28 Nov 2007 09:41:22 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding mutex locking
References: <474CF06C.8020208@lwfinger.net> <jemysy2y3y.fsf@sykes.suse.de>
In-Reply-To: <jemysy2y3y.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
>> If a particular routine needs to lock a mutex, but it may be entered with that mutex already locked,
>> would the following code be SMP safe?
>>
>> hold_lock = mutex_trylock()
>>
>> ...
>>
>> if (hold_lock)
>> 	mutex_unlock()
> 
> When two CPUs may enter the critical region at the same time, what is
> the point of the mutex?  Also, the first CPU may unlock the mutex while
> the second one is still inside the critical region.

Thank you for that answer. I think that I'm finally beginning to understand.

Larry
