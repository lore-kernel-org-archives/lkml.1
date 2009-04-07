Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbZDGHlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbZDGHlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbZDGHkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:40:52 -0400
Received: from iona.labri.fr ([147.210.8.143]:33863 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbZDGHkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:40:51 -0400
Message-ID: <49DB0388.1040408@inria.fr>
Date: Tue, 07 Apr 2009 09:40:56 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       David Rientjes <rientjes@google.com>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
References: <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com> <87r609jtc2.fsf@basil.nowhere.org> <20090407111539.F0F5.A69D9226@jp.fujitsu.com> <49DAF003.1070605@inria.fr> <20090407070530.GJ17934@one.firstfloor.org>
In-Reply-To: <20090407070530.GJ17934@one.firstfloor.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Well, some user-space application may use these distances
>> to improve their binding.
>>     
>
> I'm not aware of any that does.

We have some people here that would like to use it ideally. But they
know numa distances is almost never available, so they don't really look
at using them...

> If it's true then the correct place would be to fix the BIOS.
>   

Come on, you know it's not going to happen for 99.9% on the existing
opteron boxes. We have many hardware quirks in the kernel, I don't see
why this numa distance problem would not deserve its own work around.


By the way, anybody looked at this on Nehalem boxes ?

Brice

