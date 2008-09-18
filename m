Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbYIRXQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbYIRXQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbYIRXQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:16:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:14825 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbYIRXQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L3guH6gGYcWggEcXfuP7+ZyyxmGcPkxK6vp0cedAuwIlYWIqJ8i70XT3Ceu39lmKHh
         h/k+aYY2ERGUI5EgmFnhpKeiaSP/VDG7lRRmbF922ArVJvncky1IgvRhUYwd+DZMdAQt
         nqmfaePAEe/OnkX+7lKmilvnAAzDG8ZCJLxHo=
Message-ID: <28c262360809181616p481f9126p50c9a8c971fbbf9e@mail.gmail.com>
Date: Fri, 19 Sep 2008 08:16:43 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: Populating multiple ptes at fault time
Cc: "Christoph Lameter" <cl@linux-foundation.org>,
       "Martin Bligh" <mbligh@google.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Hugh Dickens" <hugh@veritas.com>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <48D2D4C7.8080209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D142B2.3040607@goop.org>
	 <33307c790809181411j41a6fc4ev8560a13ed8661ec2@mail.gmail.com>
	 <48D2C46A.5030702@linux-foundation.org>
	 <33307c790809181421k52ed6a36h9d4ee40d5799a536@mail.gmail.com>
	 <48D2C8DD.4040303@linux-foundation.org>
	 <28c262360809181449v1050c1f7ndf17dadba9fac0bf@mail.gmail.com>
	 <48D2CEF3.6060308@linux-foundation.org>
	 <33307c790809181508v2e64c0a4j8f0e93df99673e63@mail.gmail.com>
	 <48D2D22B.2070408@linux-foundation.org> <48D2D4C7.8080209@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 7:23 AM, Chris Snook <csnook@redhat.com> wrote:
> Christoph Lameter wrote:
>>
>> Martin Bligh wrote:
>>>>
>>>> My patches were only for anonymous pages not for file backed because
>>>> readahead
>>>> is available for file backed mappings.
>>>
>>> Do we populate the PTEs though? I didn't think that was batched, but I
>>> might well be wrong.
>>
>> We do not populate the PTEs and AFAICT PTE population was assumed not to
>> be
>> performance critical since the backing media is comparatively slow.
>>
>
> Perhaps we should.  In a virtual guest, the backing media is often an
> emulated IDE device, or something similarly inefficient, such that the
> bottleneck is the CPU.

In embedded environment, many people use nand-like device as storage.
Read cost of nand-like device is less than IDE's one.
Also, Nowaday Embedded stuff would like to use multi-core step by step.
So, pte population become important more and more.


> -- Chris
>



-- 
Kinds regards,
MinChan Kim
