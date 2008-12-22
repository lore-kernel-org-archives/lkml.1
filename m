Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYLVOzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYLVOzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 09:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYLVOzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 09:55:39 -0500
Received: from mail.klingt.org ([86.59.21.178]:42486 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588AbYLVOzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 09:55:39 -0500
Message-ID: <20081222155520.83816t3ghfflq1ds@mail.klingt.org>
Date: Mon, 22 Dec 2008 15:55:20 +0100
From: "Tim Blechmann" <tim@klingt.org>
To: "Robert Richter" <robert.richter@amd.com>
Cc: "Tim Blechmann" <tim@klingt.org>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, "Andi Kleen" <ak@linux.intel.com>
Subject: Re: 2.6.28-rc9: oprofile regression
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.2)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (klingt.org [86.59.21.178]); Mon, 22 Dec 2008 15:55:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> i am experiencing an issue, similar to the one reported in
>>> http://lkml.org/lkml/2008/10/30/319.
>>
>> bisecting showed, that commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8
>> (oprofile: Implement Intel architectural perfmon support) caused the
>> problem.
>> oddly, the newly introduced api is not used, since the model struct is
>> set during the ppro_init call ...
>
> Tim,
>
> I just tested rc9 on a system I have available and I could not
> reproduce this.
>
> cpu family	: 6
> model		: 15
> model name	: Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
> stepping	: 2
>
> Does fix 7c64ade53a6f977d73f16243865c42ceae999aea work on your system?

7c64ade53a6f977d73f16243865c42ceae999aea has been included in rc9, but still
i experience this issue ...

the only difference to my cpu is the stepping (i have stepping 6) ... also, in
case it matters, i am running a 64bit kernel ...

tim

---------------------------------------------------------------
diese nachricht wurde ueber klingt.org gesendet
this message was sent through klingt.org's webmail.

