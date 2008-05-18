Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbYERTb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbYERTb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbYERTbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 15:31:19 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46117 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbYERTbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 15:31:18 -0400
Date: Sun, 18 May 2008 22:29:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
Message-ID: <20080518192918.GJ8140@cs181133002.pp.htv.fi>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <482FD9F2.8080204@goop.org> <20080518180811.GI8140@cs181133002.pp.htv.fi> <4830768B.1090902@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4830768B.1090902@goop.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 07:33:47PM +0100, Jeremy Fitzhardinge wrote:
> Adrian Bunk wrote:
>> Even more important:
>> How do you want to handle kconfig variables set to "m"?
>>
>> Expand them to 0.5 ?  ;-)
>>   
>
> Doesn't much matter.  We can't do "#ifdef CONFIG_FOO == m" anyway.

Yes, we can:

  #ifdef CONFIG_FOO_MODULE

>    J

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

