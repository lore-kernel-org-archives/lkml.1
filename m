Return-Path: <linux-kernel-owner+w=401wt.eu-S2992443AbXBIRLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992443AbXBIRLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992445AbXBIRLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:11:33 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:37878 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992443AbXBIRLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:11:32 -0500
Message-ID: <45CCAB48.9010906@gmail.com>
Date: Fri, 09 Feb 2007 18:11:36 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, bwalle@suse.de, rmk+lkml@arm.linux.org.uk,
       rth@twiddle.net
Subject: Re: [PATCH 01/34] __initdata cleanup - alpha
References: <200702091711.34441.alon.barlev@gmail.com>	 <200702091713.23091.alon.barlev@gmail.com> <45CCA58C.90604@gmail.com> <9e0cf0bf0702090852g273e254dj71e06c9133cffd0c@mail.gmail.com>
In-Reply-To: <9e0cf0bf0702090852g273e254dj71e06c9133cffd0c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alon Bar-Lev napsal(a):
> On 2/9/07, Jiri Slaby <jirislaby@gmail.com> wrote:
>> > -static char __initdata command_line[COMMAND_LINE_SIZE];
>> > +static char __initdata command_line[COMMAND_LINE_SIZE] = "";
>>
>> Why is this "= 0" to static global variables needed?
> 
> Please review http://lkml.org/lkml/2007/1/22/267

Ok, thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
