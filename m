Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbYBYFsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbYBYFsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 00:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYBYFsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 00:48:03 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:21630 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752160AbYBYFsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 00:48:01 -0500
Message-ID: <47C25684.9060601@panasas.com>
Date: Sun, 24 Feb 2008 21:47:48 -0800
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Change a WARN message in checkpatch
References: <20080114232913.2555d392@paolo-desktop> <20080128145605.GI12910@shadowen.org> <4d8e3fd30801280713n7139223fj91adca85c76b60ad@mail.gmail.com> <4d8e3fd30802230538k7be1cc6bja9130e65fc6f5997@mail.gmail.com> <47C18AAB.7050503@panasas.com> <4d8e3fd30802241014g503c78a2wc08bd1939657802b@mail.gmail.com> <20080225032944.GA30294@shadowen.org>
In-Reply-To: <20080225032944.GA30294@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Feb 2008 05:47:49.0744 (UTC) FILETIME=[F4853700:01C87771]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb. 24, 2008, 19:29 -0800, Andy Whitcroft <apw@shadowen.org> wrote:
> On Sun, Feb 24, 2008 at 07:14:13PM +0100, Paolo Ciarrocchi wrote:
>> On Sun, Feb 24, 2008 at 4:18 PM, Benny Halevy <bhalevy@panasas.com> wrote:
>> [...]
>>>  How about:
>>>  -                               WARN("no space between function name and open parenthesis '('\n" . $herecurr);
>>>  +                               WARN("there should be no space between function name and open parenthesis '('\n" . $herecurr);
>> I originally suggested:
>> +                               WARN("don't put a space between
>> function name and open parenthesis '('\n" . $herecurr);
>> but I really prefer your version.
>>
>>>  The original phrasing can be interpreted like "there is no space between ..." and the correct
>>>  interpretation should be "there should be no space between ..."
>> Indeed.
> 
> As we want the messages to be as short as possible, I am leaning towards
> standardising on:
> 
> 	spaces prohibited <where>
> 	spaces required <where>

Sounds good to me.

Benny

> 
> -apw

