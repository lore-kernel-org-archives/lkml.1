Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbYBKKtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbYBKKtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbYBKKta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:49:30 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:56166 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbYBKKt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:49:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=O7JUeLKHH7rWA14ZA+L5hzzdNZRvEf6DJGLL12Erohnuw5BiHYEvmtkSVcvnwqH3cvjaOaiCH4oEZ6SadVeqiKuTAscLpyDzfFfC+hX70XH7O4O4Q3TktKGEurwfZ98x5G9ue8F++oi8rPZDg6+9LD/rHYSRLndgO68Z4Igj8Bo=
Message-ID: <47B0282D.2050703@gmail.com>
Date: Mon, 11 Feb 2008 19:49:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, alan@redhat.com, jeff@garzik.org
Subject: Re: [PATCH] libata: Forcing PIO0 mode on reset must not freeze	system
References: <20080210195556.GA5261@homac> <47AFB4DB.1000204@gmail.com> <20080211102907.GC4646@homac.suse.de>
In-Reply-To: <20080211102907.GC4646@homac.suse.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Holger Macht wrote:
>> In the above example, even the reset sequence itself can cause hang if
>> the hardware is implemented slightly differently.  The reason why
>> set_piomode() locks up but reset sequence doesn't is simple dumb luck.
> 
> Another thing, whether it's poor luck or not, it worked like this than at
> least 2.6.22. And it was _heavily_ tested. The above commit broke it
> between 2.6.24-rc1 and 2.6.24-rc2, which is at least a regression.

Yes, in a sense but the change is in the area where there's no defined
behavior, so I don't think it's a good idea to revert the change here.
Let's concentrate on finding the proper solution.

Thanks.

-- 
tejun
