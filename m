Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbYLLDfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbYLLDfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 22:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbYLLDex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 22:34:53 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:52758 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbYLLDew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 22:34:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NxHsCcArRZ4et/X+Ge2JM+woydQxXoPNA60G6y51/bKT+eL/klm5abkJ5fdvqECvlz
         RLHkzg3eulqj5mLme+5n7XIbKMyR8/XC31JVHW0mjIprFgJzM02xlGKT5V1i+B+zXuaq
         JWNJXCHF21HmfF7xc2irCq4bPlC+3v973gsdo=
Message-ID: <aec7e5c30812111934w50b263e0pe35c1152963fed61@mail.gmail.com>
Date: Fri, 12 Dec 2008 12:34:50 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] clocksource: add enable() and disable() callbacks
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, lethal@linux-sh.org,
       tglx@linutronix.de, mingo@redhat.com
In-Reply-To: <20081211190821.9f4b5a5c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211114909.17624.85712.sendpatchset@rx1.opensource.se>
	 <20081211190821.9f4b5a5c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 12:08 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 11 Dec 2008 20:49:09 +0900 Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> From: Magnus Damm <damm@igel.co.jp>
>>
>> Add enable() and disable() callbacks for clocksources. This allows
>> us to put unused clocksources in power save mode. The functions
>> clocksource_enable() and clocksource_disable() wrap the callbacks
>> and are inserted in the timekeeping code to enable before use and
>> disable after switching to a new clocksource.
>>
>> Signed-off-by: Magnus Damm <damm@igel.co.jp>
>> Acked-by: John Stultz <johnstul@us.ibm.com>
>> ---
>>
>>  Same as before, but applies on top of the new read() patch.
>
> I asusme we'll be seeing some patches which _use_ these changes?

I've send a few iterations of my SuperH CMT timer patches to the
linux-sh list, but I'd be happy to post next version to lkml instead
if you prefer that!

The CMT driver also needs the following patches:

[PATCH] clocksource: pass clocksource to read() callback
[PATCH][RFC] early platform driver support

Any comments on the early platform driver code?

Thanks,

/ magnus
