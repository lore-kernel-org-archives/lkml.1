Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbXI2Pyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbXI2Pyo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 11:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbXI2Pyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 11:54:37 -0400
Received: from bizon.gios.gov.pl ([212.244.124.8]:48839 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbXI2Pyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 11:54:36 -0400
Date: Sat, 29 Sep 2007 17:54:32 +0200 (CEST)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Strange system hangs
In-Reply-To: <200709290614.02918.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709291746010.30793@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709281005340.17152@bizon.gios.gov.pl>
 <200709290614.02918.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-781584652-1191081272=:30793"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-781584652-1191081272=:30793
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 29 Sep 2007, Nick Piggin wrote:

> On Friday 28 September 2007 18:42, Krzysztof Oledzki wrote:
>> Hello,
>>
>> I am experiencing weird system hangs. Once about 2-5 weeks system freeze=
s
>> and stops accepting remote connections, so it is no longer possible to
>> connect to most important services: smtp (postfix), www (squid) or even
>> ssh. Such connection is accepted but then it hangs.
>>
>> What is strange, that previously established ssh session is usable. It i=
s
>> possible to work on such system until you do something stupid like "less
>> /var/log/all.log". Using strace I found that process blocks on:
>
> Is this a regression? If so, what's the most recent kernel that didn't sh=
ow
> the problem?

I don't know. First kernel I ran was 2.6.20.x. This is quite fresh system.

> The symptoms could be consistent with some place doing a
> balance_dirty_pages while holding a lock that is required for IO, but I c=
an't
> see a smoking gun (you've got contention on i_mutex, but that should be
> OK).
>
> Can you see if there is any memory under writeback that isn't being
> completed (sysrq+M), also a list the locks held after the hang might be
> helpful (compile in lockdep and sysrq+D)

OK. I'll try to do it next time if there will be a chance. It may take=20
some time, BTW.

> Is anything currently running? (sysrq+P and even a full sysrq+T task list
> could be useful).

I'll have to check - maybe I have this captured. If not I'll check it next=
=20
time.

> Are any IO errors occurring at all?

Didn't notice - so no.

Thank you.

Best regards,


 =09=09=09Krzysztof Ol=EAdzki
---187430788-781584652-1191081272=:30793--
