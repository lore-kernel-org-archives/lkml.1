Return-Path: <linux-kernel-owner+w=401wt.eu-S1423645AbXEAEWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423645AbXEAEWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423642AbXEAEWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:22:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48215 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423645AbXEAEWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 00:22:03 -0400
Message-ID: <4636C133.3060806@oracle.com>
Date: Mon, 30 Apr 2007 21:25:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Neela Kolli <Neela.Kolli@engenio.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] megaraid: fix CONFIG_PROC_FS compile errors
References: <Pine.LNX.4.64.0704291658140.1822@chino.kir.corp.google.com>	<20070430084414.be98e552.randy.dunlap@oracle.com> <20070430192544.5ee78178.akpm@linux-foundation.org>
In-Reply-To: <20070430192544.5ee78178.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 30 Apr 2007 08:44:14 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> On Mon, 30 Apr 2007 07:35:00 -0700 (PDT) David Rientjes wrote:
>>
>>> Only declare mega_proc_dir_entry() in CONFIG_PROC_FS.  We should call
>>> mega_create_proc_entry() only in this configuration so make sure it's defined
>>> if we call it.
>>>
>>> Only define mega_adapinq() in CONFIG_PROC_FS.  mega_internal_dev_inquiry()
>>> and mega_print_inquiry() were never declared without CONFIG_PROC_FS so
>>> make sure we don't have prototypes for them if we aren't going to define
>>> them.
>>>
>>> Move the declaration of 'buf' in mega_remove_one() because we only use it
>>> in the CONFIG_PROC_FS case.
>> Just noting the presence of:
>>   http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/megaraid-fix-warnings-when-config_proc_fs=n.patch
>>
> 
> That patch has been submitted fourteen times in the past year, and was
> completely ignored each time.
> 
>> Oh, and that SCSI patches need to go to the linux-scsi mailing list.
>>
> 
> There seem to be little point in doing that.

Yes, I guess I was speaking theory instead of reality.

I suppose that one alternative is for you to merge those long-queued
patches instead of sending them on to linux-scsi over and over again.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
