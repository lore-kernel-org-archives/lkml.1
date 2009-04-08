Return-Path: <linux-kernel-owner+w=401wt.eu-S933025AbZDHLy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbZDHLy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932427AbZDHLay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:30:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44173 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437AbZDHLax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:30:53 -0400
Message-ID: <49DC8AE5.8010005@jp.fujitsu.com>
Date: Wed, 08 Apr 2009 20:30:45 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] [1/4] x86: MCE: Make polling timer interval per CPU
References: <20090407506.675031434@firstfloor.org>	<20090407150654.071D21D046E@basil.firstfloor.org>	<49DC1D7E.4010802@jp.fujitsu.com> <877i1va0j3.fsf@basil.nowhere.org>
In-Reply-To: <877i1va0j3.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>> +	if (!*n)
>>> +		*n = check_interval * HZ;
>>> +	if (!*n)
>>>  		return;
> 
> The !*n will return for check_interval == 0 because 0*HZ is still 0 so it should be 
> equivalent. Did I miss something?

At First, *n is 0 on boot.
And then soon it will be initialized to non-zero (check_interval * HZ)
by the first if-statement.

After that if check_interval is changed via sysfs while *n is non-zero,
which if-statement runs?


Thanks,
H.Seto
