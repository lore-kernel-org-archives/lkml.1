Return-Path: <linux-kernel-owner+w=401wt.eu-S1763097AbXKNGJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763097AbXKNGJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 01:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbXKNGJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 01:09:45 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:33305 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbXKNGJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:09:44 -0500
Date: Wed, 14 Nov 2007 07:09:40 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: khali@linux-fr.org, i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/i2c: Drop redundant includes of moduleparam.h
In-Reply-To: <alpine.LFD.0.9999.0711131632490.26111@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0711140707120.25487@ask.diku.dk>
References: <Pine.LNX.4.64.0711132231080.18337@ask.diku.dk>
 <alpine.LFD.0.9999.0711131632490.26111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> From: Julia Lawall <julia@diku.dk>
>>
>> Drop #include <linux/moduleparam.h> in files that also include #include
>> <linux/module.h>.  module.h includes moduleparam.h already.
>
> i'm not convinced that's a good idea.  while module.h does currently
> (and unfortunately) include moduleparam.h, there may come a day when
> those header files are refactored to actually make sense, at which
> point all those missing moduleparam.h inclusions will cause all sorts
> of bad things to happen.

They were removed from the drivers/media files in August:
9c12224a607a4b22ab86784e3394b52810b9507c
Perhaps they should be put back there then?

julia

