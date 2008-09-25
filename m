Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYIYTix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYIYTix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYIYTip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:38:45 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:26859 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbYIYTio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:38:44 -0400
Message-ID: <48DBE8C3.2060708@ct.jp.nec.com>
Date: Thu, 25 Sep 2008 12:38:43 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 -tip 0/4] x86: signal handler improvement
References: <48DBD396.5020103@ct.jp.nec.com> <48DBD519.6030204@zytor.com> <48DBD8A6.8060900@ct.jp.nec.com> <48DBD96F.6090309@zytor.com>
In-Reply-To: <48DBD96F.6090309@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hiroshi Shimamoto wrote:
>>> This is a gcc failure, and should be reported to the gcc people.
>> Does this gcc failure mean unnecessary storing into stack?
>>
> 
> Yes, it should be able to process this in a register, instead of storing 
> to the stack and then merging later.
> 
> It's possible it's trying to do that to hide latency, but that's clearly 
> a lose in this case.

OK, I'll test with some gcc versions.
It's necessary to check outputs of the latest gcc, I think.

thanks,
Hiroshi Shimamoto
