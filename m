Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbXKDQUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbXKDQUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 11:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbXKDQUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 11:20:06 -0500
Received: from orion2.pixelized.ch ([195.190.190.13]:48572 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbXKDQUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 11:20:04 -0500
Message-ID: <472DF121.8000509@cateee.net>
Date: Sun, 04 Nov 2007 17:19:45 +0100
From: Giacomo Catenazzi <cate@cateee.net>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: David Miller <davem@davemloft.net>, mingo@elte.hu, sam@ravnborg.org,
       thomas@archlinux.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
References: <20071103121149.GA22149@uranus.ravnborg.org> <20071104020217.GJ12045@stusta.de> <20071104100429.GA12311@elte.hu> <20071104.023133.241080055.davem@davemloft.net> <20071104152930.GL12045@stusta.de>
In-Reply-To: <20071104152930.GL12045@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Nov 04, 2007 at 02:31:33AM -0800, David Miller wrote:
>> From: Ingo Molnar <mingo@elte.hu>
>> Date: Sun, 4 Nov 2007 11:04:29 +0100
>>
>>> * Adrian Bunk <bunk@kernel.org> wrote:
>>>
>>>> I also have CFLAGS set on some computers in my environments since for 
>>>> packages using GNU autoconf that's the correct way to set the compiler 
>>>> flags.
>>>>
>>>> The kernel already sets all flags correctly, and a user wanting to 
>>>> change the flags for the kernel is an exception with very special 
>>>> needs (I'd even claim so special that he could simply edit the 
>>>> Makefile...).
>>  ...
>>> At minimum the extra CFLAGS needs to be put into the .config - but 
>>> that's not a too nice solution either. How about just adding an 
>>> extra-CFLAGS option to .config and perhaps a 'make configpickupCFLAGS' 
>>> pass for anyone who wants to propagate the environment CFLAGS into the 
>>> kernel build.
>> I totally disagree.
>>
>> People can't have it both ways.  CFLAGS has global meaning in every
>> Makefile based build tree, it's not an "autoconf" thing.  This is well
>> established practice, and I think it's a good thing the kernel does it
>> now too.
> 
> Makefiles do normally not pick such variables from the environment.

????

Are you sure???

 From http://www.gnu.org/software/make/manual/make.html#Environment

: Variables in make can come from the environment in which make
: is run. Every environment variable that make sees when it starts
: up is transformed into a make variable with the same name and
: value.

and most important:

: Thus, by setting the variable CFLAGS in your environment, you
: can cause all C compilations in most makefiles to use the
: compiler switches you prefer. This is safe for variables with
: standard or conventional meanings because you know that no
: makefile will use them for other things. (Note this is not
: totally reliable; some makefiles set CFLAGS explicitly and
: therefore are not affected by the value in the environment.)

ciao
	cate

