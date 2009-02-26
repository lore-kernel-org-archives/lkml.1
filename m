Return-Path: <linux-kernel-owner+w=401wt.eu-S1757690AbZBZCSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbZBZCSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 21:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZBZCSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 21:18:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40048 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbZBZCSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 21:18:10 -0500
Message-ID: <49A5FADB.30002@zytor.com>
Date: Wed, 25 Feb 2009 18:13:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/4] uaccess: add copy_word_from_user
References: <20090225203007.582030664@goodmis.org> <20090225203427.382137706@goodmis.org> <49A5F81F.6060604@zytor.com> <20090226021031.GA7553@nowhere>
In-Reply-To: <20090226021031.GA7553@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Wed, Feb 25, 2009 at 06:02:07PM -0800, H. Peter Anvin wrote:
>> Steven Rostedt wrote:
>>> This patch creates a copy_word_from_user function that can copy
>>> a space delimited word from user space. This puts the code in
>>> a new lib/uaccess.c file. This keeps the code in a single location
>>> and may be optimized in the future.
>> I have a bit of an issue with the naming... at least *I* read this as  
>> copying a machine word, which made me wonder why you didn't just use  
>> "get_user".  I would suggest copy_token_from_user or something like that.
>>
>> 	-hpa
> 
> That was the first impression I had too (the sense of a machine word).
> But token seems to me imprecise as well, too much generic.
> 
> Well, since it is well commented, I guess it's not so much an issue...
> 

Well, "word" has the problem that someone looking at a call site is 
likely to get the wrong idea.  "token" may make them confused, but that 
means they'll try to look it up.  However, I'm sure we could do better.

	-hpa

