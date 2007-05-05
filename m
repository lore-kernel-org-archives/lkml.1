Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbXEEUH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbXEEUH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbXEEUH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:07:59 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:23652 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbXEEUH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:07:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=LIcoVsIji6BbomVpBf2Kw6Bb2hWxD6MrBWhkVZc9tfgQTe4PLOdOt6y8uy/31L30Zfp5pdtRsV/pAtFofvVz3L5ZJPvO3TwI9z7rmzMHobtXnBARMNnGmTIjGunK3t+XZo63zGRtibP1xiTzfdTuxe7mLih7im3f1SVob+enlYo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Subject: Re: [PATCH] use mutex instead of semaphore in IDE driver
Date: Sat, 5 May 2007 20:55:35 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070426092032.GB6468@traven>
In-Reply-To: <20070426092032.GB6468@traven>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705052055.36061.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 26 April 2007, Matthias Kaehlcke wrote:
> the IDE driver uses a semaphore as mutex. use the mutex API instead of
> the (binary) semaphore
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

applied
