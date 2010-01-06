Return-Path: <linux-kernel-owner+w=401wt.eu-S932398Ab0AFWZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0AFWZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932327Ab0AFWZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:25:22 -0500
Received: from toro.web-alm.net ([62.245.132.31]:51940 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259Ab0AFWZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:25:20 -0500
Message-ID: <4B450D91.7060403@osadl.org>
Date: Wed, 06 Jan 2010 23:24:17 +0100
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Clark Williams <williams@redhat.com>
CC: John Kacur <jkacur@redhat.com>, RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [rt-tests] change to cyclictest behavior
References: <20100106130400.7f30ae55@torg>	<520f0cf11001061139j2af13403qfcbf567647bdfaa8@mail.gmail.com>	<4B4502FD.1000404@osadl.org> <20100106160434.77efc790@torg>
In-Reply-To: <20100106160434.77efc790@torg>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clark,

>> [..]
>> Here is my proposal:
>> Do not change the meaning of existing options. Introduce a new option
>> that is mutual exclusive with the -a, the -t and the -d option. This new
>> option does the same as -a and -t and -d0 and sets the same priority to
>> all threads. How about that?
> Ugh, I truly *hate* adding options. Do you know that cyclictest is
> halfway to having as many options as 'ls'?
Well, yes, we have the choice between two bad things, breaking
compatibility or adding another option. I prefer the latter.
> [..]
> How about if we create the -S/--smp option that takes no arguments and
> causes -a, -t and -d to be ignored (with a warning). This option would
> create one thread per cpu, each thread pinned to it's corresponding
> cpu, all with the same sampling interval (i.e. -d0) and the same
> priority?
Sounds good to me.

May I ask you to also include the -n option which is almost always
needed? This would then give:

-S      --smp              Standard SMP testing (equals -a -t -n -d0),
                           same priority on all threads.

	Carsten.
