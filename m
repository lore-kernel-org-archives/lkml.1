Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbYJHUyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbYJHUyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbYJHUyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:54:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59947 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYJHUyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:54:01 -0400
Message-ID: <48ED1DE2.6010406@firstfloor.org>
Date: Wed, 08 Oct 2008 22:53:54 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.14 (X11/20060911)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: ksoftirqd accounting broken in 2.6.27-rc9
References: <20081008173757.GA24560@one.firstfloor.org> <200810082134.28345.rjw@sisk.pl>
In-Reply-To: <200810082134.28345.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Wednesday, 8 of October 2008, Andi Kleen wrote:
>> On one test box running 2.6.27rc9 for a few hours I got:
>>
>>   PID TTY      STAT   TIME COMMAND
>>     1 ?        Ss     0:01 init [3]  
>>     2 ?        S<     0:00 [kthreadd]
>>     3 ?        S<     0:00 [migration/0]
>>     4 ?        S<     0:00 [ksoftirqd/0]
>>     5 ?        S<     0:00 [watchdog/0]
>>     6 ?        S<     0:00 [migration/1]
>>     7 ?        S<     0:00 [ksoftirqd/1]
>>     8 ?        S<     0:00 [watchdog/1]
>>     9 ?        S<     0:00 [migration/2]
>>    10 ?        S<   21133795:38 [ksoftirqd/2]
>> ...
>>    19 ?        S<   21133795:38 [ksoftirqd/5]
>> ...
>>    25 ?        S<   21133795:38 [ksoftirqd/7]
>>
>> The other kernel threads seem to have correct accounting.
> 
> It looks like http://bugzilla.kernel.org/show_bug.cgi?id=11209, doesn't it?

Yes, looks like a dup of that one. Thanks.

-Andi



