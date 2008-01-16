Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbYAPTVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbYAPTVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYAPTVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:21:08 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41639 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbYAPTVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:21:07 -0500
Message-ID: <478E5926.7070100@davidnewall.com>
Date: Thu, 17 Jan 2008 05:51:10 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: righiandr@users.sourceforge.net
CC: David Newall <david@davidnewall.com>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH] per-task I/O throttling
References: <47869FFE.1050000@users.sourceforge.net> <4787779B.1070100@davidnewall.com> <47878EC1.4000907@users.sourceforge.net>
In-Reply-To: <47878EC1.4000907@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> David Newall wrote:
>   
>> Andrea Righi wrote:
>>     
>>> [I/O-intensive] processes can noticeably impact the system responsiveness
>>> for some time and playing with tasks' priority is not always an
>>> acceptable solution.
>>>   
>>>       
>> Why?
>>
>>     
>
> Well, I mean, we can't use 'nice' to grant less priority for the I/O
> intensive app, because the I/O intensive app itself doesn't need a lot
> of CPU. Instead, the I/O-bound app eats all the available I/O bandwidth,
> that's a different issue.

That's what I was thinking.  Your original, "not always an acceptable
solution," made me wonder if you were referring to something obscure.
