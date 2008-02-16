Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYBPTcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYBPTcA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756621AbYBPTbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:31:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557AbYBPTbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:31:51 -0500
Message-ID: <47B73A22.60806@zytor.com>
Date: Sat, 16 Feb 2008 11:31:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] kernel/{exit.c, signal.c, power/process.c}: replace
 !likely(x) by likely(!x)
References: <47B70810.5030608@tiscali.nl> <47B732EF.4050504@zytor.com> <47B739AA.6070108@tiscali.nl>
In-Reply-To: <47B739AA.6070108@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> H. Peter Anvin wrote:
>> Roel Kluin wrote:
>>> Not entirely sure who to send this to
>>> ---
>>> Replace !likely(x) by likely(!x)
>> Whoa...
>>
>> Are you sure this is correct?
>>
>> !likely(x) is equivalent to unlikely(!x), not the opposite, so this is a
>> functional change...
>>
> You are right, sorry, Need more caffeine. I will send the right patch later.

Note I didn't say it was wrong, I just wanted a bit more explanation 
about why it's right, if it is.

	-hpa
