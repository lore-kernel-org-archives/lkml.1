Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbYERIsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbYERIsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 04:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYERIrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 04:47:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:22155 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYERIrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 04:47:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=pZrvyPbU5+x1hOJTShnsPz02xJT/Haf6TcPTJX7ZNeVxPKo+kSh60d/ZCF1T+MYnwBfEDIea4MttCORvSlY1u0Wra2DIPFPYV3vG6iL+6J8dzfb5MKJ6Y00BPJFPehJ1RsHWHcz5iOjNfpcjB8A+RQdnMqTxkCPjTPROlJ+VSfY=
Date: Sun, 18 May 2008 12:47:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
Message-ID: <20080518084738.GC6948@cvg>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <482FD9F2.8080204@goop.org> <20080518073804.GB6948@cvg> <482FE9CA.4090804@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482FE9CA.4090804@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jeremy Fitzhardinge - Sun, May 18, 2008 at 09:33:14AM +0100]
> Cyrill Gorcunov wrote:
>> I think I would prefer Maciej's advice then but with capital
>> letters (to easy distinguish them and point an attention) like
>>
>> #ifdef CONFG_X86_64
>> #define CPU_64 1
>> #else
>> #define CPU_64 0
>> #endif
>
> The other problem in this case is that cpu_pda() doesn't exit for 32-bit, 
> so it probably won't compile anyway.  But in general, I fully support using 
> if (constant) over #ifdef (?: not so much).
>
>    J
>

Since it's a compile-time known path I hope gcc just throw it out before checking
for existance. But not tried yet ;)

		- Cyrill -
