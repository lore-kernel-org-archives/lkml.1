Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbYLMHKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbYLMHKj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 02:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYLMHKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 02:10:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55625 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbYLMHKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 02:10:33 -0500
Message-ID: <49435F92.5070102@cn.fujitsu.com>
Date: Sat, 13 Dec 2008 15:09:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Pavel Emelyanov <xemul@openvz.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 1/1] devices cgroup: allow mkfifo
References: <20081211155027.GB12750@us.ibm.com> <20081211191208.d4d251ad.akpm@linux-foundation.org> <20081212143458.GC9571@us.ibm.com>
In-Reply-To: <20081212143458.GC9571@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> hm.  I'd looked at your description and decided this was 2.6.29 material.
>>
>> But you think it's for 2.6.28 and even for 2.6.27.  How come?
>>
>> (iow, your changelog sucked :)
> 
> Sorry, I should have put the exchange between Li and I in there.
> (Ouch, and I didn't cc: Li this time!  Sorry, Li.)
> 
> Li thought it was 2.6.27/2.6.27 material.  I thought not, but wanted
> to see what the -stable folks thought.
> 

I was not sure about this.

> This is not a security hole, and since noone has complained before
> it doesn't appear to be too inconvenient.  Until the fix goes
> up, container users can always create the fifos and socks on the
> root image while creating the container, before entering the
> device whitelist.
> 

Now the explanation makes it clear for me, thx. :)


