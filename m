Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZKCNvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZKCNvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZKCNvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:51:37 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46102 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbZKCNvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:51:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HdQ/i/EF2yJyeswXdZY+BWkHA0KjSITcy1iKKeFfv1peMR8P3JrYPRTO+G6qt4A7xA
         LK2nQDhVaR9n7BsGuavU/1CgT3PXSQDrdzBXWQt5Qd5Idxwmp0yXbRsBzWbzUsy3SRHk
         oEVf/Gkp5Ev/JwbTO3kI8p0W0se8X/OMq1Log=
MIME-Version: 1.0
In-Reply-To: <63386a3d0910251518i42149642g183f2d3f6c43384f@mail.gmail.com>
References: <1256078002-27919-1-git-send-email-linus.walleij@stericsson.com>
	 <63386a3d0910251518i42149642g183f2d3f6c43384f@mail.gmail.com>
Date: Tue, 3 Nov 2009 14:51:41 +0100
Message-ID: <63386a3d0911030551j1accd6fby7038895df544385b@mail.gmail.com>
Subject: Re: [PATCH] Make MIPS dynamic clocksource/clockevent clock code 
	generic v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
       Mikael Pettersson <mikpe@it.uu.se>, Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/25 Linus Walleij <linus.ml.walleij@gmail.com>:
> 2009/10/21 Linus Walleij <linus.walleij@stericsson.com>:
>
>> Changes v1->v2:
>> - Fixed Mikaels comments: spelling, terminology.
>> - Kept the functions inline: all uses and foreseen uses
>>  are once per kernel and all are in __init or __cpuinit sections.
>> - Unable to break out common code - the code is not common and
>>  implementing two execution paths will be more awkward.
>> - Hoping the tglx likes it anyway.
>
> Ping on tglx on this, I will uninline the functions if you think
> it's better in the long run, just tell me, else can you pick this
> patch?

Ping again...

Linus Walleij
