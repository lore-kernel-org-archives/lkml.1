Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0CHQW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:22:27 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36391 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab0CHQWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:22:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pMtKtmSevqgVpuerLeiQsPlWZd7VYXFEXls2ZMZa1ydj34C3KCySIF5ltcEA8Ve7+Y
         Dea6ZGzGNjwGdbRFhMKC9TWo1hL21eeb/u8Y5Dt3AAvoB5gESWDQw83MqspIa7kHQJ8A
         4rDdQAlJyYazxkPqYQy8jpPk1ow3SCw7d/I8I=
Message-ID: <4B952437.8020607@gmail.com>
Date: Mon, 08 Mar 2010 11:22:15 -0500
From: jim owens <owens6336@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
       Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag
 (EXT4_IOC_MOVE_EXT) in 32bit compat mode)
References: <201003072132.10579.borntraeger@de.ibm.com> <4B94367E.9080506@garzik.org> <201003080853.42978.borntraeger@de.ibm.com> <4B9518DA.8010201@davidnewall.com>
In-Reply-To: <4B9518DA.8010201@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Christian Borntraeger wrote:
>> Some bigger things are missing in the e4defrag tool:
>> ...
>> - overall layout considerations (e.g. putting files close to its
>> directory or
>>   use the atime to move often used files to the beginning of a disk etc.)
> 
> Shouldn't oft-used files be placed closer to the middle?  If you place
> them at the beginning of the file, it's only possible for the head-stack
> to be close to the file from the inner direction.  Place them in the
> middle and it's possible for the head-stack to be close from the outer
> direction, too, which sounds like a doubling of probability.  It seems
> that it's the least frequently used files that should be placed at one
> end of the disk or the other.

No.  Your logic would be correct if rotating disks had
similar speed at all locations.  Current disks are much
faster at the 0 end than at the middle or highest address.

It is not unusual to see 2x difference in transfer speed
so you always want the important stuff as low as possible.

jim
