Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZLKJOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZLKJOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 04:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZLKJOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:14:02 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44098 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbZLKJOB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:14:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UuYnmgXgfmXMzBu75FIcq5UUA5KEaZJC0V8JUnEHDx4pDsqBDQbzY1I3lFoaDuhS0a
         0fD3gxmOU7w+0n5lsJpAycVTTgb7n3XSgZglYO4cNkf3DJn0Afb07SmqVz1wLNJfYUC+
         OFJ6hmuyDfW5QX2lzbrnvxYKRiCFpThaXvrhc=
MIME-Version: 1.0
In-Reply-To: <1260522580.2442.22.camel@johannes.local>
References: <a8e1da0912100127k4dcddd65gfe5ff0b1330fe63b@mail.gmail.com>
	 <a8e1da0912100130i2e654796mf899dd27df869673@mail.gmail.com>
	 <20091210184931.257A.A69D9226@jp.fujitsu.com>
	 <20091210.142932.78191007.davem@davemloft.net>
	 <1260522580.2442.22.camel@johannes.local>
Date: Fri, 11 Dec 2009 17:14:06 +0800
Message-ID: <a8e1da0912110114g19e4b767yf491fe383abb8c03@mail.gmail.com>
Subject: Re: mmotm-2009-12-08-17-45 resume slowly
From: Dave Young <hidave.darkstar@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 5:09 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-12-10 at 14:29 -0800, David Miller wrote:
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Date: Thu, 10 Dec 2009 18:52:51 +0900 (JST)
>>
>> > (cc to netdev)
>> >
>> > Hi net-folks
>> >
>> >> > [  ,A 561.323866] mtrr: type mismatch for e0000000,10000000 old:
>> >> > write-back new: write-combining
>> >> > [ 2688.500033] No probe response from AP 00:02:2d:08:51:2b after
>> >> > 500ms, disconnecting.
>> >> > [ 2689.580376] wlan0: direct probe to AP 00:02:2d:08:51:2b (try 1)
>> >
>> > What's mean "No probe response"? Why its point waste 2000sec?
>>
>> I think you'll get more responses from the wireless list,
>> replacing netdev with linux-wireless in the CC:...
>
> That is definitely done asynchronously, there's no reason it should
> delay the resume.

Yes, agree too. Please see my another reply. the darkness of screen
make me post more kernel messages then needed.

>
> johannes
>



-- 
Regards
dave
