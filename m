Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZGFTWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZGFTWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZGFTWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:22:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33579
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964AbZGFTWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:22:31 -0400
Date: Mon, 06 Jul 2009 12:22:38 -0700 (PDT)
Message-Id: <20090706.122238.212724277.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: wuzhangjin@gmail.com, jeff.chua.linux@gmail.com,
       etienne.basset@numericable.fr, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-ide@vger.kernel.org
Subject: Re: [Bug #13663] suspend to ram regression (IDE related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200907061658.00936.bzolnier@gmail.com>
References: <200907031508.47891.bzolnier@gmail.com>
	<1246635096.16890.6.camel@falcon>
	<200907061658.00936.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 6 Jul 2009 16:57:59 +0200

>> I think it's better to revert this commit:
>>  a1317f714af7aed60ddc182d0122477cbe36ee9b ("ide: improve handling of
>> Power Management requests")
>  
> I completely agree and I've already requested this a week ago
> (this commit was not meant for going straight to -rc tree anyway).

I'll revert this today and push that to Linus.
