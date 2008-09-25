Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYIYSaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYIYSaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYIYS37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:29:59 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:36238 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbYIYS36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:29:58 -0400
Message-ID: <48DBD8A6.8060900@ct.jp.nec.com>
Date: Thu, 25 Sep 2008 11:29:58 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 -tip 0/4] x86: signal handler improvement
References: <48DBD396.5020103@ct.jp.nec.com> <48DBD519.6030204@zytor.com>
In-Reply-To: <48DBD519.6030204@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hiroshi Shimamoto wrote:
>> and errors in __put_user is stored to stack.
>> At the end of function, all errors in stack are calculated. If access to user
>> space is failed, %edx is set to -EFAULT in exception handler and stored to
>> stack for later operation.
>> It seems inefficient.
>>
> 
> This is a gcc failure, and should be reported to the gcc people.

Does this gcc failure mean unnecessary storing into stack?

thanks,
Hiroshi Shimamoto

