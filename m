Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbZAETSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbZAETSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZAETRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:17:47 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:43000 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbZAETRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:17:46 -0500
Message-ID: <4961C83A.6020009@davidnewall.com>
Date: Mon, 05 Jan 2009 19:13:38 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Chris Adams <cmadams@hiwaay.net>, linux-kernel@vger.kernel.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>	<20090102210430.49649261@diego-desktop>	<495E7849.4030706@shaw.ca>	<495F0672.6020708@davidnewall.com>	<8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com>	<496076A9.7030907@davidnewall.com>	<f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>	<4960897D.5030603@davidnewall.com>	<alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>	<4961432A.80509@davidnewall.com>	<20090104232534.GB1297917@hiwaay.net>	<49614DD8.7070707@davidnewall.com> <20090105004123.374709ff@lxorguk.ukuu.org.uk>
In-Reply-To: <20090105004123.374709ff@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> zoneinfo.  Epoch remains the start of  1978; seconds between any two
>> dates included leap-seconds and no special kernel support is required.
>>     
>
> Your time() values then disagree with the rest of the universe. See POSIX
> 1003.1 Annex B 2.2.2. if you want the whole story,
>   

I can't find this, except possibly (but maybe not) at a cost from ieee,
and I'm not inclined to pay.  If you could post a sentence from this
annex it might help me to find it.


> For any given time based on the 1970 Epoch there is a single correct
> answer for the translation between each value and a UTC time.

This confused me because the sense that I've got from this thread
suggests otherwise.  Unless I've misunderstood, the time() value for the
first second of 2009 is one greater than the value for the second to
last second of 2008 (i.e. 23:59:59), which means that there is no
translation for the last second.  Put another way, my understanding of
what's been said is that the epoch is effectively increased by one
second for each leap second.  Have I got this wrong?
