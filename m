Return-Path: <linux-kernel-owner+w=401wt.eu-S932772Ab0AFWv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab0AFWv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932530Ab0AFWvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:51:25 -0500
Received: from toro.web-alm.net ([62.245.132.31]:52291 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380Ab0AFWvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:51:25 -0500
Message-ID: <4B4513BA.5090001@osadl.org>
Date: Wed, 06 Jan 2010 23:50:34 +0100
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Clark Williams <williams@redhat.com>
CC: John Kacur <jkacur@redhat.com>, RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [rt-tests] change to cyclictest behavior
References: <20100106130400.7f30ae55@torg>	<520f0cf11001061139j2af13403qfcbf567647bdfaa8@mail.gmail.com>	<4B4502FD.1000404@osadl.org>	<20100106160434.77efc790@torg>	<4B450D91.7060403@osadl.org> <20100106162759.1d4d5b57@torg>
In-Reply-To: <20100106162759.1d4d5b57@torg>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clark,

>> [..]
>> May I ask you to also include the -n option which is almost always
>> needed? This would then give:
>> -S      --smp              Standard SMP testing (equals -a -t -n -d0),
>>                            same priority on all threads.
> Yeah, you read my mind. How about -m (mlockall) as well?
Hmm, I think that this one is less obvious. Apparently, there are a
bunch of different opinions on mlockall(). I once heard, for example,
the opinion that mlockall() may - under some conditions - introduce a
performance penalty, but I did not verify that. Many real-time systems
do not have a "swap" line in /etc/fstab; mlockall() is not needed in
such systems. In addition, most today's systems have so much RAM that
swapping became a rather rare event. I hope some other RT-ers who are
more knowledgeable about memory management and swapping can comment on this.

Cyclictest was in use for years, before someone introduced the -m
option. I never used this option.

	Carsten.
