Return-Path: <linux-kernel-owner+w=401wt.eu-S1758494AbYDUDa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494AbYDUDa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 23:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYDUDaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 23:30:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:16931 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbYDUDaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 23:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=WIzL0HOLQQ3mwggQZvnJ6O98N+FsQZFy0hXAB8zrhvpObaDXEOAcSh7qJlAzWMTfxrNgXEmKhUUEI1bK+bJlTMPzHo439F5rLPRZqJRn14I+Fl4PfO12gNF+Bq37ix5qzJGh0UT/R4JLn3P5hBLCl4GXotMP3AmsEgIoalzjhiw=
Message-ID: <480C0A39.7080501@gmail.com>
Date: Mon, 21 Apr 2008 09:30:01 +0600
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.1.12) Gecko/20080129 Iceape/1.1.8 (Debian-1.1.8-2) Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Arjan van de Ven <arjan@infradead.org>, Eric Sandeen <sandeen@sandeen.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <20080420120250.4f496861@the-village.bc.nu> <20080420115455.GJ1595@cs181133002.pp.htv.fi> <20080420123731.7282bb16@the-village.bc.nu> <20080420121803.GK1595@cs181133002.pp.htv.fi> <480B4DB4.8070107@sandeen.net> <20080420084127.2fc324ec@laptopd505.fenrus.org> <20080420160327.GE1899@cs181133002.pp.htv.fi>
In-Reply-To: <20080420160327.GE1899@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Apr 20, 2008 at 08:41:27AM -0700, Arjan van de Ven wrote:
>> ...
>> yes. Adrian is waay off in the weeds on this one. Nobody but him is suggesting to remove
>> 8Kb stacks. I think everyone else agrees that having both options is valuable; and there
>> are better ways to find+fix stack bloat than removing this config option.
> 
> I'm not arguing for removing the option immediately, but long-term we 
> shouldn't need it.
> 
> This comes from my experience of removing obsolete drivers for hardware 
> for which also a more recent driver exists:
> As long as there is some workaround (e.g. using an older driver or
> 8k stacks) the workaround will be used instead of the getting proper 
> bug reports and fixes.
> 
> As far as I know all problems that are known with 4k stacks are some 
> nested things with XFS in the trace.

This "as far as I know" is a problem itself. Is it possible to implement (e.g., 
using some form of memory protection in hardware, but I am not an expert here) 
an option with 8k stacks that, however, spams the log if the actual usage goes 
above 4k, and have this as a default for some time? If 4k stacks are the goal 
that is almost achieved, then this debugging option should have zero impact on 
performance.

-- 
Alexander E. Patrakov
