Return-Path: <linux-kernel-owner+w=401wt.eu-S1752963AbYHFMg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbYHFMg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYHFMg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:36:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:30898 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbYHFMg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:36:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ODOgTQZTRiE0G4jAcCN37fQ0ueWCC3F3U2WJhAtqEQMva2GQzK1DL6rIB7mYcnjQov
         cYT9BpZHlzUvpqGIO3uDyAXzeTGRXCvOKwvY3Uk91Nacr8ndToio7iBMhbtBOJNt5y7F
         SlwPhFNddFaB7F1HWBuTDvKAJJ2PONzGIbMLU=
Message-ID: <2f11576a0808060536o53cabb93m6387d35e3e5791be@mail.gmail.com>
Date: Wed, 6 Aug 2008 21:36:27 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: No, really, stop trying to delete slab until you've finished making slub perform as well
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Mel Gorman" <mel@skynet.ie>,
       andi@firstfloor.org, "Rik van Riel" <riel@redhat.com>
In-Reply-To: <48986AC6.5030406@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2f11576a0808040947r69076eecv9ff92ecf583f7af2@mail.gmail.com>
	 <489738CF.7090401@linux-foundation.org>
	 <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48986AC6.5030406@linux-foundation.org>
X-Google-Sender-Auth: 994d05e4617631c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Can you quantify the difference?
>>
>> machine spec:
>> CPU: IA64 x 8
>> MEM: 8G (4G x2node)
>
> 16k or 64k page size?

64k.


>> So, about 2.5G - 3G difference in 8G mem.
>
> Well not sure if that tells us much. Please show us the output of
> /proc/meminfo after each run. The slab counters indicate how much memory is
> used by the slabs.
>
> It would also be interesting to see the output of the slabinfo command after
> the slub run?

ok.
but i can't do that in this week.
so, I'll do it in next week.

honestly, I don't know how to use slabinfo command :-)
