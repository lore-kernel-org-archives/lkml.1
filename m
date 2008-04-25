Return-Path: <linux-kernel-owner+w=401wt.eu-S933221AbYDYWkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbYDYWkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbYDYWkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:40:17 -0400
Received: from rv-out-0708.google.com ([209.85.198.251]:62410 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755213AbYDYWkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:40:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=IL7oYbLjKsWAe7kkKNzHShFUxlu7nNu2Wzn07kiT7oR5dLGTSxvUE4mwQXUwD7cmBNx0yzOpS5rBc9AQ7+vrR/g3auquZv3RAQ/G5O2N+jurwbVSHHTLQ7FpWyB1ZRFxLi5aRyeD7ZKgKwGyA8c4xlGnNLtqGWYYKcWPS+uLmnc=
Message-ID: <48125DC4.4000705@gmail.com>
Date: Sat, 26 Apr 2008 07:40:04 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, oliver@neukum.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, zaitcev@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2 UPDATED] klist: implement KLIST_INIT() and	DEFINE_KLIST()
References: <480DB6A4.20101@gmail.com> <1208869049.7115.254.camel@twins> <480DE215.2070803@gmail.com> <1208869591.7115.263.camel@twins> <480DE3B3.6050702@gmail.com> <20080425163736.GC10397@kroah.com> <48121FE4.5010803@gmail.com> <20080425223027.GA12643@kroah.com>
In-Reply-To: <20080425223027.GA12643@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Apr 26, 2008 at 03:16:04AM +0900, Tejun Heo wrote:
>> klist is missing static initializers and definition helper.  Add them.
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> ---
>> Updated to use _name.k_lock as advised.
> 
> Thanks, was there a 2/2 patch in this series as well that I should be
> applying?

Yeap, it's named "[PATCH] klist: implement klist_add_{after|before}()". 
  I forgot to add "2/2".

Thanks.

-- 
tejun
