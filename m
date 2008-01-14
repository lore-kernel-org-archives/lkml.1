Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbYANTTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbYANTTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYANTTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:19:11 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:9912 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbYANTTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:19:10 -0500
Message-ID: <478BB5A6.1070702@ct.jp.nec.com>
Date: Mon, 14 Jan 2008 11:19:02 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_32: remove warning message not used
References: <478BB226.6090105@ct.jp.nec.com> <20080114190904.GA2288@elte.hu>
In-Reply-To: <20080114190904.GA2288@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> smp_num_siblings hasn't been updated at this point yet, so it's always 
>> 1. This polling and HT warning message is never shown.
> 
> hah, nice one. But could you perhaps move it to a place where it has a 
> chance to be printed? The warning still makes sense.
> 

yeah, you're right. I'll do.

Thanks,
Hiroshi Shimamoto
