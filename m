Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbZDIVAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbZDIVAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758519AbZDIU75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:59:57 -0400
Received: from smtp-out.google.com ([216.239.45.13]:6857 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434AbZDIU74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:59:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=np4l4AZBTnu5KSKNLdkAQY2rEgbZ4vqN5wQEJzcberkPKcwtbgqaVbsPF8YBl9gNu
	RiB2J+OHWHzdRAG+bhTRA==
MIME-Version: 1.0
In-Reply-To: <20090409133030.a7ea94c7.akpm@linux-foundation.org>
References: <1238715399-22172-1-git-send-email-jack@suse.cz>
	 <a4a7801d0904031738h68bf6218lfd3349ca50f46642@mail.gmail.com>
	 <20090406102329.GD31189@duck.suse.cz>
	 <20090409133030.a7ea94c7.akpm@linux-foundation.org>
Date: Thu, 9 Apr 2009 13:59:50 -0700
Message-ID: <604427e00904091359t3e068ffm1868d164824fb575@mail.gmail.com>
Subject: Re: [PATCH] ext2: Fix data corruption for racing writes
From: Ying Han <yinghan@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, yinghan@gmail.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, nickpiggin@yahoo.com.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 9, 2009 at 1:30 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 6 Apr 2009 12:23:29 +0200
> Jan Kara <jack@suse.cz> wrote:
>
>> >
>> > I tried this patch and seems i got deadlock on the truncate_mutex.
>> > Here is the message after enabling lockdep. I pasted the same message
>> > on the origianal thread.
>>
>> ...
>>
>>   I don't think this is a deadlock (or is the machine hung?). The thread
>> was just waiting for a long time. I'd think that you'll occasionally get
>> exactly the same message even without my patch if you stress the machine
>> like you do.
>>
>
> Well, it's easy to tell the difference
>
> deadlock: system never recovers
> long-sucky-delay: system eventually recovers.
>
> Which was it??
Guess i have to retest it. I didn't wait long enough to see what
happened on the machine. However, i do see the machine got rebooted
later, but i am not sure what is the reason it is got reboot.

I will rerun the patch and keep an eye on it this time.

--Ying
>
