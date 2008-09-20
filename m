Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYITO2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYITO2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 10:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYITO2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 10:28:21 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:40836 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYITO2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 10:28:21 -0400
Message-ID: <48D50883.6040700@weinigel.se>
Date: Sat, 20 Sep 2008 16:28:19 +0200
From: Christer Weinigel <christer@weinigel.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, Russ Dill <russ.dill@gmail.com>,
       Eric Miao <eric.y.miao@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: kernel.h: add ARRAY_AND_SIZE() macro to complement	ARRAY_SIZE().
References: <20080918132447.516309749@fluff.org.uk> <20080918150624.GA3421@x200.localdomain> <f17812d70809181138xb0e4d4bs8a6361bb038b5a6e@mail.gmail.com> <20080919065426.GA7222@lenovo> <f17812d70809190022u6c862ae8j43b1c1a942e22497@mail.gmail.com> <f9d2a5e10809190828g54a824b9od1ade53c96a518c8@mail.gmail.com> <20080919175544.GA3228@x200.localdomain> <48D4F519.2080509@weinigel.se> <20080920134543.GA7354@localhost>
In-Reply-To: <20080920134543.GA7354@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [Christer Weinigel - Sat, Sep 20, 2008 at 03:05:29PM +0200]
>> Alexey Dobriyan wrote:
>>> On Fri, Sep 19, 2008 at 08:28:45AM -0700, Russ Dill wrote:
>>>> My vote is for ARRAY_AND_SIZE to spread far and wide across the land.
>>>> ARRAY_SIZE is already very safe, as it has a __must_be_array macro
>>>> built in. So ARRAY_AND_SIZE is even safer, as it prevents you from
>>>> mixing up two different arrays. It also reduces line length and makes
>>>> driver and device (usually platform_device) registration code easier
>>>> to read.
>>> It also spreads ARRAY_SIZE misnaming futher.
>> You still haven't explained what's misnamed about it, nor suggested a  
>> better name.
> Christer, _I_ was complaining not about naming
> but about hiding function arguments. I suppose
> it's better to define some inline wrapper for
> platform_add_devices then use such a macro.

Sorry about that.  I should have commented the earlier one.

In my opinion, making platform_add_devices into a magic macro is 
actually worse, since the same construct (array, ARRAY_SIZE(array)) is 
used in many places, so one would have to do the same thing over and 
over again for every function.  In that case it's better to have to 
learn one macro once, and the ALL_CAPITALS should make it obvious that 
it is a macro.

  /Christer

