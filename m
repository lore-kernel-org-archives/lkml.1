Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbXGEOOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbXGEOOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbXGEOOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:14:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:60950 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbXGEOOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:14:08 -0400
Message-ID: <468CFCA1.3080104@anagramm.de>
Date: Thu, 05 Jul 2007 16:13:53 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Uli Luckas <u.luckas@road.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca> <468AA364.2010000@nortel.com> <468AB976.2010806@redhat.com> <200707041056.53992.u.luckas@road.de> <20070704165313.GC4306@sequoia.sous-sol.org>
In-Reply-To: <20070704165313.GC4306@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX194ShoQz/X87Q1OWyL754G+0i71Dz9aqxSGFsT
 f73/FTLnXXNsfwQmvb29nDRA/F2VZkxLBfTWksh/aNooZCE/Po
 cMfHZKCAH1SnK5bcZ801A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Chris!

Chris Wright schrieb:
> * Uli Luckas (u.luckas@road.de) wrote:
>> On Tuesday, 3. July 2007, Chuck Ebbert wrote:
>>> On 07/03/2007 03:28 PM, Chris Friesen wrote:
>>>> Arne Georg Gleditsch wrote:
>>>>> An interesting exercise might be to
>>>>> code up a small program to call adjtimex with timex.status |= STA_INS,
>>>>> to see if this can trigger the problem.
>>>> Setting the date to just before midnight June 30 UTC and then running
>>>> the following as root triggered the crash on a modified 2.6.10.  Anyone
>>>> see anything wrong with the code below, or is this a valid indication of
>>>> a bug in the leap second code?
>>> Fixed:
>>> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=comm
>>> itdiff;h=746976a301ac9c9aa10d7d42454f8d6cdad8ff2b
>>>
>> Hi Chris,
>> does that qualify for inclusion into 2.6.21.6?
> 
> Yes, it has already been sent to -stable.

Okay, we all survived Y2K and this little glitch. Puh! ;-)
Can you please explain in which configuration this problem got triggered.

Does it make sense to have some testing environments which have the date
set to about one month in the future to catch any crashes like that,
preventing machines in production from failing?!

Best regards,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
