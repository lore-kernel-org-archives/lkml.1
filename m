Return-Path: <linux-kernel-owner+w=401wt.eu-S932704AbXCXSsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbXCXSsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 14:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932787AbXCXSsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 14:48:12 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36075 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704AbXCXSsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 14:48:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<20070323185022.GQ752@stusta.de> <46055A3B.6050107@m3y3r.de>
	<m1slbu4j0p.fsf@ebiederm.dsl.xmission.com> <46056BF3.3070707@m3y3r.de>
Date: Sat, 24 Mar 2007 12:47:50 -0600
In-Reply-To: <46056BF3.3070707@m3y3r.de> (Thomas Meyer's message of "Sat, 24
	Mar 2007 19:20:35 +0100")
Message-ID: <m1odmi4gx5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer <thomas@m3y3r.de> writes:

> Eric W. Biederman schrieb:
>> Thomas Meyer <thomas@m3y3r.de> writes:
>>
>>   
>>> Adrian Bunk schrieb:
>>>     
>>>> Subject    : second suspend to disk in a row results in an oops  (libata?)
>>>> References : http://lkml.org/lkml/2007/3/17/43
>>>> Submitter  : Thomas Meyer <thomas@m3y3r.de>
>>>> Status     : unknown
>>>>   
>>>>       
>>> The problem is identified: http://lkml.org/lkml/2007/3/22/150
>>>     
>>
>> Given the description above I'm a little confused.  Doesn't this
>> happen every time now?
>>   
> With current git head the oops happens in the second suspend to disk
> attempt in a row.

Odd.  I would have thought the oops happened in the first resume, not
the second. 

Hmm.  It may have something to do with the ``managed'' driver
aspect of this as well..

>> Or was this happening only the second time before I started my msi
>> fixes... 
>>   
> So i think, that the current git head already contains your msi fixes.

Yes it does.

> I don't know if this already happend before your msi changes, but i can
> test 2.6.20 if you like to?

Sure.  A data point if you boot with nomsi or have a kernel compiled
without msi support would be interesting as well.

As the problem case may not show up without msi support in the picture.

Eric

