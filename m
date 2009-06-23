Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbZFWXB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbZFWXB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbZFWXBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:01:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37337
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757403AbZFWXBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:01:19 -0400
Date: Tue, 23 Jun 2009 16:01:23 -0700 (PDT)
Message-Id: <20090623.160123.142620779.davem@davemloft.net>
To: elendil@planet.nl
Cc: bzolnier@gmail.com, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-cd: Improve "weird block size" error message
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906232330.20519.elendil@planet.nl>
References: <200906230951.24615.elendil@planet.nl>
	<20090623.035926.155211513.davem@davemloft.net>
	<200906232330.20519.elendil@planet.nl>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>
Date: Tue, 23 Jun 2009 23:30:18 +0200

> On Tuesday 23 June 2009, David Miller wrote:
>> ide-cd: Don't warn on bogus block size unless it actually matters.
>>
>> Frans Pop reported that his CDROM drive reports a blocksize of 2352,
>> and this causes new warnings due to commit
>> e8e7b9eb11c34ee18bde8b7011af41938d1ad667 ("ide-cd: fix oops when using
>> growisofs").
>>
>> What we're trying to do is make sure that "blocklen >> SECTOR_BITS"
>> is something the block layer won't choke on.
>>
>> And for Frans case "2352 >> SECTOR_BITS" is equal to
>> "2048 >> SECTOR_BITS", and thats "4".
> 
> Pedantic correction: Frans' case

Corrected, thanks.

>> So warning in this case gives no real benefit.
>>
>> Reported-by: Frans Pop <elendil@planet.nl>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> As expected, it's gone. Nice.
> 
> Tested-by: Frans Pop <elendil@planet.nl>

Applied, thanks for testing!
