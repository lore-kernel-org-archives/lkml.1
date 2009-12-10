Return-Path: <linux-kernel-owner+w=401wt.eu-S1761170AbZLJR1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761170AbZLJR1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760895AbZLJR1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:27:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:38613 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760874AbZLJR1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:27:21 -0500
References: <20091210091040.GG8742@kernel.dk> <20091210103945.GI8742@kernel.dk> <20091210160640.GB27794@elte.hu>
Message-Id: <67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org>
From: Yinghai <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091210160640.GB27794@elte.hu>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: Bisected regression (Was Re: current -git fails to boot on nehalem-ex)
Date: Thu, 10 Dec 2009 09:26:45 -0800
Cc: Jens Axboe <jens.axboe@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





On Dec 10, 2009, at 8:06 AM, Ingo Molnar <mingo@elte.hu> wrote:

>
> * Jens Axboe <jens.axboe@oracle.com> wrote:
>
>> On Thu, Dec 10 2009, Jens Axboe wrote:
>>> Hi,
>>>
>>> As written in the subject, it just hard hangs before writing  
>>> anything on
>>> the console. With earlyprintk, I captured the failure, see below.
>>>
>>> I'll try and bisect this, but it takes some time (since the bios and
>>> post process takes forever). I just updated the firmware on the  
>>> box as
>>> well, but it did boot 2.6.32 (and RHEL5 boots fine too). Of course  
>>> that
>>> doesn't rule out a BIOS bug.
>>
>> Results are persistent, git bisect points to:
>>
>> commit b24c2a925a9837cccf54d50aeac22ba0cbc15455
>> Author: Yinghai Lu <yinghai@kernel.org>
>> Date:   Tue Nov 24 02:48:18 2009 -0800
>>
>>    x86: Move find_smp_config() earlier and avoid bootmem usage
>>
>> which appears consistent with the panic(). Reverting that does indeed
>> make current -git boot properly.
>
> Thanks. Yinghai, do you have any ideas, or should we revert it?
>
Let find the root cause

Jen

Can you boot with earlyconsole or earlyprintk and debug?

YH
