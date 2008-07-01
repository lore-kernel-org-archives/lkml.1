Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbYGAKCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbYGAKCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 06:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYGAKB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 06:01:56 -0400
Received: from nebensachen.de ([195.34.83.29]:55793 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbYGAKB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 06:01:56 -0400
X-Hashcash: 1:20:080701:edwintorok@gmail.com::WaC+m1gwZw/QHLtR:000000000000000000000000000000000000000006uAv
X-Hashcash: 1:20:080701:alan@lxorguk.ukuu.org.uk::w7+lQ8TTKqaq2aNv:00000000000000000000000000000000000000JSL
X-Hashcash: 1:20:080701:joe@skyrush.com::xY1JphxA66/tBr55:001GB/
X-Hashcash: 1:20:080701:linux-kernel@vger.kernel.org::WLRDyiY0U7SCtcGn:0000000000000000000000000000000009U0k
From: Elias Oltmanns <eo@nebensachen.de>
To: =?iso-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joe Peterson <joe@skyrush.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local>
	<87abh2rpzg.fsf@denkblock.local> <4869EABD.1090009@gmail.com>
Date: Tue, 01 Jul 2008 11:59:23 +0200
In-Reply-To: <4869EABD.1090009@gmail.com> (=?iso-8859-1?Q?=22T=F6r=F6k?=
 Edwin"'s message of "Tue, 01
	Jul 2008 11:28:45 +0300")
Message-ID: <87prpyx6v8.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Török Edwin <edwintorok@gmail.com> wrote:
> Elias Oltmanns wrote:
[...]
>> Since commit ec5b1157f8e819c72fc93aa6d2d5117c08cdc961, users have been
>> unable to interrupt interactive processes reliably by pressing CTRL+C.
>> This patch reverts the original commit except for the most important
>> part: actually echoing ^C is preserved.
>>   
>
> Thanks for the patch , the process seems to respond faster to Ctrl-C,
> but I'll have to find a way to measure that reliably.
> However ^C is not echoed anymore for me.

Very odd, it most definitely is echoed here. Are you quite sure you
haven't inadvertently changed anything else in the meantime?

Regards,

Elias
