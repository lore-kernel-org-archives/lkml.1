Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab0CHQbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:31:55 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57871 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab0CHQbu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:31:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RUGSMzN85bDxx3H+CgmDCc7aMHBSoHbk7br+tojRrPeHglfiiYqAU/5xqDREWalhUn
         Pn29fNeyOhNnHI/z+7x8dvmm0v3rjSm4MxraPAUlRYZKJ+bo+WnYWIIw8yhOQietq3j2
         temB6KgAJuihwMV6YcVOJwduGhe/z8t2X8neg=
MIME-Version: 1.0
In-Reply-To: <4B952437.8020607@gmail.com>
References: <201003072132.10579.borntraeger@de.ibm.com>
	 <4B94367E.9080506@garzik.org>
	 <201003080853.42978.borntraeger@de.ibm.com>
	 <4B9518DA.8010201@davidnewall.com> <4B952437.8020607@gmail.com>
Date: Mon, 8 Mar 2010 11:31:49 -0500
Message-ID: <87f94c371003080831n4d310e10i2b9badf4290f1ede@mail.gmail.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag 
	(EXT4_IOC_MOVE_EXT) in 32bit compat mode)
From: Greg Freemyer <greg.freemyer@gmail.com>
To: jim owens <owens6336@gmail.com>
Cc: David Newall <davidn@davidnewall.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 8, 2010 at 11:22 AM, jim owens <owens6336@gmail.com> wrote:
> David Newall wrote:
>> Christian Borntraeger wrote:
>>> Some bigger things are missing in the e4defrag tool:
>>> ...
>>> - overall layout considerations (e.g. putting files close to its
>>> directory or
>>>   use the atime to move often used files to the beginning of a disk etc.)
>>
>> Shouldn't oft-used files be placed closer to the middle?  If you place
>> them at the beginning of the file, it's only possible for the head-stack
>> to be close to the file from the inner direction.  Place them in the
>> middle and it's possible for the head-stack to be close from the outer
>> direction, too, which sounds like a doubling of probability.  It seems
>> that it's the least frequently used files that should be placed at one
>> end of the disk or the other.
>
> No.  Your logic would be correct if rotating disks had
> similar speed at all locations.  Current disks are much
> faster at the 0 end than at the middle or highest address.
>
> It is not unusual to see 2x difference in transfer speed
> so you always want the important stuff as low as possible.
>
> jim

Jim, I should know this, but is sector 0 on the outside edge, or the inner edge?

I assume outer so that the linear speed of the platter under the head
is faster and thus more data per second is passing under the head.

Greg
