Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbXKUM3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbXKUM3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 07:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbXKUM3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 07:29:45 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:41208 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbXKUM3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 07:29:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=mAQTlPhcKrB3dXPYFtg65UdCnLUGJR+XqiMS9zR1/PAihuZEQ83Z4rAX1Cc47sOPLst8PWBPg60lWLm1a9vpSWUWk2Jc55UiWTmy9k/Q1M+tuU+d6pbQLwkCWJpUKI92;
Message-ID: <15058.simon.1195648180@5ec7c279.invalid>
In-Reply-To: <2097618015@web.de>
References: <2097618015@web.de>
Date: Wed, 21 Nov 2007 12:29:40 -0000
Subject: Re: System reboot triggered by just reading a device file....!?
From: "Simon Arlott" <simon@fire.lp0.eu>
To: devzero@web.de
Cc: "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, November 21, 2007 00:01, devzero@web.de wrote:
>>There is.. it's called "root privileges".
> yes, true.
>
> but - regardless of being a windows app or not - what if you want to take a look on your system as a whole,
> especially when using some tool which graphically shows how and where your diskspace is being used?  if i
> let this run from ordinary useraccount it would get lot`s of "permission denied"  and then it`s only telling
> half of the truth.....

Such a tool shouldn't need to open any files, whether they're device files or not. Do you expect it to open
/dev/zero etc. too and read from an infinitely sized "file"?

>> > i`d wish there would be some fence around this or iTCO_wdt /dev/watchdog not being active after a
>> default desktop installation.

Delete it?

-- 
Simon Arlott
