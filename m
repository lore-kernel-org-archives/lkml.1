Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbYKXJzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbYKXJzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYKXJzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:55:43 -0500
Received: from smtp.nokia.com ([192.100.122.230]:19838 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYKXJzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:55:42 -0500
Message-ID: <492A7BFD.7000206@nokia.com>
Date: Mon, 24 Nov 2008 12:03:41 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: ext Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: Artem Bityutskiy <dedekind@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBIFS: fix compilation warnings
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org> <1227287970-14684-5-git-send-email-dedekind@infradead.org> <20081122185429.GA21433@Chamillionaire.breakpoint.cc>
In-Reply-To: <20081122185429.GA21433@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Nov 2008 09:54:43.0981 (UTC) FILETIME=[AD4423D0:01C94E1A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Andrzej Siewior wrote:
> * Artem Bityutskiy | 2008-11-21 19:19:26 [+0200]:
> 
>> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>>
>> We print 'ino_t' type using '%lu' printk() placeholder, but this
>> results in many warnings when compiling for Alpha platform. Fix
>> this by adding (unsingned long) casts.
>>
>> Fixes these warnings:
>>
>> fs/ubifs/journal.c:693: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> 
> Wouldn't %z help? A cast sounds wrong.

Doesn't help:

fs/ubifs/journal.c:699: warning: format ‘%zu’ expects type ‘size_t’, but argument 4 has type ‘ino_t’
