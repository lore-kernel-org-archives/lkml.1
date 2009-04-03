Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbZDCPBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbZDCPBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764191AbZDCPBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:01:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50039 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbZDCPBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:01:19 -0400
Message-ID: <49D624A9.1040002@redhat.com>
Date: Fri, 03 Apr 2009 10:00:57 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: add fiemap.h to header-y
References: <200904030459.n334xVpS019935@hera.kernel.org> <20090403064640.GA13075@uranus.ravnborg.org>
In-Reply-To: <20090403064640.GA13075@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:

>> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
>> index a67b622..ca9b9b9 100644
>> --- a/include/linux/Kbuild
>> +++ b/include/linux/Kbuild
>> @@ -67,6 +67,7 @@ header-y += falloc.h
>>  header-y += fd.h
>>  header-y += fdreg.h
>>  header-y += fib_rules.h
>> +header-y += fiemap.h
>>  header-y += firewire-cdev.h
>>  header-y += firewire-constants.h
>>  header-y += fuse.h
> 
> Before adding a new headers as an exported headers please fix it up.
> This headers uses __u32/__u64 but fails to include <linux/types.h>
> 
> 	Sam

Sam -

Whoops, thanks for catching that.  Will take a look & submit a patch.

Thanks,

-Eric
