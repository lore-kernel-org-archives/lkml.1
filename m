Return-Path: <linux-kernel-owner+w=401wt.eu-S1760454AbXGDKW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760454AbXGDKW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbXGDKWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:22:50 -0400
Received: from lucidpixels.com ([75.144.35.66]:51477 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757433AbXGDKWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:22:49 -0400
Date: Wed, 4 Jul 2007 06:22:48 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Michael Tokarev <mjt@tls.msk.ru>
cc: Tejun Heo <htejun@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Some NCQ numbers...
In-Reply-To: <468B6BD7.9010108@msgid.tls.msk.ru>
Message-ID: <Pine.LNX.4.64.0707040621170.32656@p34.internal.lan>
References: <468392CE.6010206@msgid.tls.msk.ru> <468A06A0.1020802@gmail.com>
 <468AB1A7.9010201@msgid.tls.msk.ru> <468AF5BB.10005@gmail.com>
 <468B6BD7.9010108@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007, Michael Tokarev wrote:

> Tejun Heo wrote:
>> Hello,
>>
>> Michael Tokarev wrote:
>>> Well.  It looks like the results does not depend on the
>>> elevator.  Originally I tried with deadline, and just
>>> re-ran the test with noop (hence the long delay with
>>> the answer) - changing linux elevator changes almost
>>> nothing in the results - modulo some random "fluctuations".
>>
>> I see.  Thanks for testing.
>
> Here are actual results - the tests were still running when
> I replied yesterday.
>
> Again, this is Seagate ST3250620AS "desktop" drive, 7200RPM,
> 16Mb cache, 250Gb capacity.  The tests were performed with
> queue depth = 64 (on mptsas), drive write cache is turned
> off.

I found AS scheduler to be the premium and best for single-user performance.

You want speed? Use AS.

http://home.comcast.net/~jpiszcz/sched/cfq_vs_as_vs_deadline_vs_noop.html

