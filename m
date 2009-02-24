Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbZBXGz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbZBXGz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 01:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZBXGzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 01:55:19 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:30122 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbZBXGzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 01:55:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=j+qiN18xCZKhuwTA1vucEr9Fn6QvYWA78zTMTJmjK5v3PN9XHXvmRsmH0cC3E35c57
         Ev5XwHd2aPNlwT2IbQw/6oJTWbG9G8T16f2bTy7mKU4A8icXMthRRvcp6TGA2aQgIto0
         W1Epv7nHqk0nbsgI5ycXoGBT2Qdft7Mih+SXQ=
Message-ID: <49A399D2.8020107@gmail.com>
Date: Mon, 23 Feb 2009 22:55:14 -0800
From: John Daiker <daikerjohn@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090216 Lightning/1.0pre Shredder/3.0b2pre
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl stalls on net/decnet/dn_fib.c
References: <499DE5CE.3030700@gmail.com> <20090223145329.GF22617@shadowen.org> <20090223151555.GG22617@shadowen.org>
In-Reply-To: <20090223151555.GG22617@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2009 07:15 AM, Andy Whitcroft wrote:
> On Mon, Feb 23, 2009 at 02:53:29PM +0000, Andy Whitcroft wrote:
>    
>> On Thu, Feb 19, 2009 at 03:05:50PM -0800, John Daiker wrote:
>>      
>>> Andy,
>>>
>>> Was running checkpatch.pl on the entire tree today (because my disk
>>> loves to get thrashed like that...)  Found what seems to be a stall/hang
>>> while running checkpatch.  I know nothing of the internal workings of
>>> checkpatch.pl, but hope that you're able to sniff this one out!
>>>
>>> ./scripts/checkpatch.pl --file ./net/decnet/dn_fib.c  --debug values=9
>>> types=9 possible=9 attr=9
>>>        
>> Hmmm, yes thats broken indeed.  Will have a look at it.
>>      
>
> Ok, think I have this one sorted.  Could you test with the version of
> checkpatch at this URL:
>
>    http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing
>
> Thanks for the report.
>
> -apw
>    
Andy,

That did the trick.  Thanks!

(Sorry if this was double-posted... user error the first time)

John
