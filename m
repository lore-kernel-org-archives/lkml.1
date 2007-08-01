Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbXHAPtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbXHAPtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbXHAPta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:49:30 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14373 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932777AbXHAPt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:49:29 -0400
Message-ID: <46B0ACC5.6010904@oracle.com>
Date: Wed, 01 Aug 2007 08:54:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Nish Aravamudan <nish.aravamudan@gmail.com>
CC: Zan Lynx <zlynx@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1 huge pages VM freeze (maybe?)
References: <1185918261.6981.13.camel@localhost>	 <20070731150245.5932b763.randy.dunlap@oracle.com> <29495f1d0708010845x446f7823qcfe2c5244b604078@mail.gmail.com>
In-Reply-To: <29495f1d0708010845x446f7823qcfe2c5244b604078@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nish Aravamudan wrote:
> On 7/31/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On Tue, 31 Jul 2007 15:44:21 -0600 Zan Lynx wrote:
>>
>>> I was playing with huge pages and libhugetlbfs.  Small programs like
>>> "ls" work fine.  I tried running Evolution through libhugetlbfs and the
>>> system slowly stops running.  One interesting thing is the "ps" command,
>>> it gets stuck like this:
>> Do you mean 2.6.22-rc1-mm1 or 2.6.23-rc1-mm1?
>>
>> There was a hugepage problem fixed very recently, in 2.6.23-rc1 IIRC.
> 
> Actually fixed just after 2.6.23-rc1:
> 
> git describe 5ab3ee7b1cd5c91eb2272764f9d7d1fe4749681e
> v2.6.23-rc1-14-g5ab3ee7

Looks to me like Andrew included Ken's patch in his rc1-mm1 anyway,
so that shouldn't be the issue.  Or did I not read mm/hugetlb.c correctly?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
