Return-Path: <linux-kernel-owner+w=401wt.eu-S1760611AbYGAU13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611AbYGAU13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbYGAU1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:27:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbYGAU1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:27:17 -0400
Message-ID: <486A9257.1050302@zytor.com>
Date: Tue, 01 Jul 2008 13:23:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com> <48695F88.9080905@goop.org> <48696167.6050000@zytor.com> <20080701195942.GA76608@atlantis.8hz.com>
In-Reply-To: <20080701195942.GA76608@atlantis.8hz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sean Young wrote:
> On Mon, Jun 30, 2008 at 03:42:47PM -0700, H. Peter Anvin wrote:
>> Jeremy Fitzhardinge wrote:
>>> Maybe it really does require the far jump immediately after setting PE 
>>> in cr0...
>>>
>>> Hm, I don't remember this paragraph being in vol 3a, section 8.9.1 
>>> before.  Is it a recent addition?
>>>
>>>   Random failures can occur if other instructions exist between steps
>>>   3 and 4 above.  Failures will be readily seen in some situations,
>>>   such as when instructions that reference memory are inserted between
>>>   steps 3 and 4 while in system management mode.
>>>
>> I don't remember that, either.
> 
> Which document are we talking about? 
> 

Intel's Software Developer's Manual, volume 3a.

> I'm afraid it doesn't work. Maybe I can find something in the AMD Elan
> documentation. Would a fence make sense?

Not really.  In particular, I really don't want to add something that is 
even remotely likely to break on other platforms, and a fence 
instruction is relatively recent.

	-hpa
