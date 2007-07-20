Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbXGTFU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbXGTFU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 01:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbXGTFUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 01:20:16 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:62089 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbXGTFUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 01:20:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qk2zG+UydHU/GDQ4R/bA+a3TmycGjloTSUFfnqTf1+KN2fTeLT9HL6GDBiqxTzAjLisjyGjKUB7hq/QXgqTYPeSnwbvDTsRj/MzwgeHlLay2YDIdAlYQeLmQf5v9s/An6cTSylSvi19bD4NAWIwd6TyVY2VyZytGuvHhpPObwYA=
Message-ID: <a8e1da0707192220x264d6675ie739b12f7ce81453@mail.gmail.com>
Date: Fri, 20 Jul 2007 05:20:12 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Al Boldi" <a1426z@gawab.com>
Subject: Re: [RFH] Partion table recovery
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200707200813.03553.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707200813.03553.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 7/20/07, Al Boldi <a1426z@gawab.com> wrote:
> As always, a good friend of mine managed to scratch my partion table by
> cat'ing /dev/full into /dev/sda.  I was able to push him out of the way, but
/dev/null ?
> at least the first 100MB are gone.  I can probably live without the first
> partion, but there are many partitions after that, which I hope should
> easily be recoverable.
>
> I tried parted, but it's not working out for me.  Does anybody know of a
> simple partition recovery tool, that would just scan the disk for lost
> partions?
>
The best way is to backup you partition table before destroyed.
