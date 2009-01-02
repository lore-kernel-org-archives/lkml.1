Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbZABU3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbZABU3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbZABU3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:29:07 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:10463 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZABU3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:29:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Xl2zmENv8jieUyzHNYnejJJT4urwxsOS7As+iPfjj+Mqf5Nmtpqo/x/ujmcVS+oOSe
         1cPN6CbEG3nnBKPEjdB/OEGb6CQABJUY6bvbYvM4qz2l3JXZ6x0CeyC5cs4Zn7Wqajwe
         KFaaJD+vuI0uDFFpmmyJipULVfcbmVElj6+RY=
Message-ID: <3ae3aa420901021229u6e2b6048xc20b1183fcbbb05c@mail.gmail.com>
Date: Fri, 2 Jan 2009 14:29:02 -0600
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "Diego Calleja" <diegocg@gmail.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>,
       Goodgerster <goodgerster@gmail.com>, burdell@iruntheinter.net
In-Reply-To: <20090102210430.49649261@diego-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <20090102210430.49649261@diego-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n02KTOwM017072

2009/1/2 Diego Calleja <diegocg@gmail.com>:> El Fri, 2 Jan 2009 13:25:38 -0600, "Linas Vepstas" <linasvepstas@gmail.com> escribiÃ³:>>> Suspect its an kernel race condition triggered by ntp bumping the second.>> How could I create a test case that reproduces what ntp does? Just add> a second?
It might be more subtle than that. One of these cases is discussed in aDebian mailing list thread, where one user claims his hardware clock runsso poorly, it  loses second every hour, and he doesn't have problems.ntp normally drifts to adjust time; for exceptional jumps in time, it won'tdrift, but just set.
There's another thread of bug reports on Oracle servers (linux based) whichappearently hit the same problem, although they think it has something todo with a backwards leap-second jump.
--linasÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
