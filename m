Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbYFMMRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbYFMMRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 08:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbYFMMQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 08:16:58 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35017 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbYFMMQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 08:16:57 -0400
Message-ID: <4852654D.9060306@bull.net>
Date: Fri, 13 Jun 2008 14:17:17 +0200
From: Benjamin Thery <benjamin.thery@bull.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] sysfs tagged directories V5
References: <20080606154654.356185262@theryb.frec.bull.fr> <20080610225024.GB22478@us.ibm.com> <20080610230058.GA25072@suse.de>
In-Reply-To: <20080610230058.GA25072@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Jun 10, 2008 at 05:50:24PM -0500, Serge E. Hallyn wrote:
>> Quoting Benjamin Thery (benjamin.thery@bull.net):
>>> Greg,
>>>
>>> Here is an updated version of the sysfs tagged directories that improves
>>> a bit the situation over the previous one. 
>>>
[...]
>>>
>>> The generic part can be merge with patch 05 ("sysfs: Implement sysfs 
>>> tagged directory support.") but I left it separate for now to ease 
>>> reviews.
>> Thanks.  Not nearly as radical as I'd feared.
>>
>> Greg, does this address your concern?  It stops the need to put any
>> non-braindead code (i.e. the _exit notifier stuff) in fs/sysfs/mount.c for
>> any new namespaces needing sysfs tagging, leaving only simple
>> comparison/assignments.
> 
> Sorry, I've been swamped with other things this week and haven't gotten
> a chance to look this over.  Hopefully by the end of the week...  It's
> in my queue though, don't worry it will not get lost.

Greg,

I've ported the patchset to 2.6.26-rc5-mm3 yesterday and I have just
finished testing it. Will this help you if I send you an up-to-date
tarball with this new version? or is it fine for you to review the 
patchset I sent last week (based on 2.6.26-rc2-mm1)?

Tell me what you prefer.

Benjamin

> 
> thanks,
> 
> greg k-h
> 
> 


-- 
B e n j a m i n   T h e r y  - BULL/DT/Open Software R&D

    http://www.bull.com
