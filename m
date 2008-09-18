Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbYIRVuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbYIRVuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 17:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbYIRVtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 17:49:43 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:34378 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbYIRVtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 17:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bGL3CC1nlADR9JGMg7ZpJP6Z7GvWbFu3M+tTw+rZ51j3+2+7Eg+ixPw+3e6rew/TqY
         /y2xUji/a1Il2mbSDDPSPi9nvyOaQ1+JBkWPr0Q+bEzZWMz+Jx/3VkTF9Sn6gHsTbIpN
         7pArEQgOfZX3oj8hmvbJlQwPCm2fh5IRd7Ei4=
Message-ID: <28c262360809181449v1050c1f7ndf17dadba9fac0bf@mail.gmail.com>
Date: Fri, 19 Sep 2008 06:49:41 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: Populating multiple ptes at fault time
Cc: "Martin Bligh" <mbligh@google.com>, "Chris Snook" <csnook@redhat.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Hugh Dickens" <hugh@veritas.com>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <48D2C8DD.4040303@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D142B2.3040607@goop.org> <48D17A93.4000803@goop.org>
	 <48D29AFB.5070409@linux-foundation.org> <48D2A392.6010308@goop.org>
	 <33307c790809181352h14f2cf26kc73de75b939177b5@mail.gmail.com>
	 <48D2BFB8.6010503@redhat.com>
	 <33307c790809181411j41a6fc4ev8560a13ed8661ec2@mail.gmail.com>
	 <48D2C46A.5030702@linux-foundation.org>
	 <33307c790809181421k52ed6a36h9d4ee40d5799a536@mail.gmail.com>
	 <48D2C8DD.4040303@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 6:32 AM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> Martin Bligh wrote:
>
>>> Well, I guess we need a new binary format that allows one to execute binaries
>>> in kernel address space with full powers.
>>
>> Seems ... extreme ;-)
>
> Well yes ....
>
>> Maybe we just do it if we're in readahead? (or similar)
>
> If we are in kernel space then the binary can call the readahead function as
> needed ... ;-O

In case of file-mapped pages, Shouldn't we use just on-demand
readahead mechanism in kernel ?
If it is inefficient, It means we have to change on-demand readahead
mechanism itself.
How about you ?

> Ok, seriously: Anonymous pages are not subject to readahead so it wont work.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Kinds regards,
MinChan Kim
