Return-Path: <linux-kernel-owner+w=401wt.eu-S933844AbYD2Rku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844AbYD2Rku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764095AbYD2Rau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:30:50 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:34577 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764057AbYD2Rat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:30:49 -0400
Message-ID: <48175B45.2030500@davidnewall.com>
Date: Wed, 30 Apr 2008 03:00:45 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Markus Metzger <markus.t.metzger@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: DS cleanup - dont treat 0 as NULL
References: <20080428191504.GA6842@cvg> <4816BEC8.1080708@davidnewall.com> <4816C258.7050203@zytor.com>
In-Reply-To: <4816C258.7050203@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> David Newall wrote:
>> Cyrill Gorcunov wrote:
>>> -            return 0;
>>> +            return NULL;
>>
>> Why?  The constant 0 is C's official symbol for a null pointer.
>
> It's still bad style.

I disagree, but I don't want to debate the point.
