Return-Path: <linux-kernel-owner+w=401wt.eu-S1030240AbXBUDIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030240AbXBUDIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 22:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030289AbXBUDIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 22:08:39 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:24496 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030240AbXBUDIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 22:08:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mRbaCw8Gzhbtc1Z2kFQtbT6GDnpB2G5Y5yC03md6hxzQ9CS18w5/W1Z7whrdwF6IpjdlPa50VD60Y+ZOCf89XSVLkUdfP8ZXs9XbilxQ3s+Nq+dBTR/QIK1eYEY0ubC/CYDymEJsOpXSdTUk2zSCw3yRaqKrC+eYfgELHvE82/k=
Message-ID: <45DBB7B4.2010405@gmail.com>
Date: Wed, 21 Feb 2007 12:08:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Pablo Sebastian Greco <lkml@fliagreco.com.ar>
CC: Marcus Haebler <haebler@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: SATA problems
References: <459A674B.3060304@fliagreco.com.ar> <459B9F91.9070908@gmail.com>	 <459BC703.9000207@fliagreco.com.ar> <459C8A5E.5010206@gmail.com>	 <459CFE7B.6090306@fliagreco.com.ar>	 <459DC2EE.1090307@fliagreco.com.ar> <45A1AB3F.1080408@gmail.com>	 <45B649BF.5030705@fliagreco.com.ar> <45B6BC6D.8070301@gmail.com> <d72aa1340702170449n1aa61777l6c9c7e525102db00@mail.gmail.com> <45D731A8.90604@fliagreco.com.ar> <45DB0717.90507@gmail.com> <45DB20CF.7080300@fliagreco.com.ar>
In-Reply-To: <45DB20CF.7080300@fliagreco.com.ar>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pablo Sebastian Greco wrote:
> Tejun Heo wrote:
>> * Pablo, the bug you saw was bad interaction between blacklisted NCQ
>> device and dynamic queue depth adjustment.  Patches are submitted to fix
>> the problem.  Just drop the blacklist patch.  Your drives should work
>> fine in NCQ mode.  My gut feeling is that your problem is power related
>> from the beginning.
>>   
> I had the same problems with a new Power Supply, Now everything is ok
> with the old Power Supply and the new drives.

So, it was bad drives?  Are you using the same model or different ones?
 NCQ works okay now?

-- 
tejun
