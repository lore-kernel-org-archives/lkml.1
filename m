Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZCCGEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZCCGEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 01:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbZCCGEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 01:04:16 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:33675 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbZCCGEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 01:04:15 -0500
Message-ID: <49ACC853.8070205@krogh.cc>
Date: Tue, 03 Mar 2009 07:04:03 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>	 <49A6F39F.9040801@krogh.cc>	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>	 <49A6FEE2.90700@krogh.cc>	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>	 <49A70B24.6090706@krogh.cc>	 <1235685269.6811.11.camel@localhost.localdomain>	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>	 <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>	 <1235766936.7402.5.camel@localhost.localdomain> <49ABACA0.3090300@krogh.cc> <1236029277.7756.0.camel@localhost.localdomain>
In-Reply-To: <1236029277.7756.0.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> On Mon, 2009-03-02 at 10:53 +0100, Jesper Krogh wrote:
>> john stultz wrote:
>>> Ok, so it seems ntp hasn't really had a chance to settle down, its only
>>> made a 10ppm adjustment so far. NTPd will stop corrections at ~
>>> +/-500ppm, so you're not at that bound yet, where things would be really
>>> broken.
>>>
>>> If the affected kernel isn't resetting in the logs anymore, I'd be
>>> interested in what the new ppm value is.
>> After 20 hours.. its still resetting.
>> Mar  2 10:43:24 quad12 ntpd[4416]: synchronized to 10.194.133.12, stratum 4
>> Mar  2 10:50:37 quad12 ntpd[4416]: time reset -1.103654 s
> 
> So what's the "ntpdc -c kerninfo" output now?

Mar  3 06:41:10 quad12 ntpd[4416]: time reset -0.813957 s
Mar  3 06:45:20 quad12 ntpd[4416]: synchronized to LOCAL(0), stratum 13
Mar  3 06:45:36 quad12 ntpd[4416]: synchronized to 10.194.133.12, stratum 4
Mar  3 06:51:57 quad12 ntpd[4416]: synchronized to 10.194.133.13, stratum 4
Mar  3 07:00:29 quad12 ntpd[4416]: time reset -0.783390 s
jk@quad12:~$ ntpdc -c kerninfo
pll offset:           0 s
pll frequency:        -28.691 ppm
maximum error:        1.0433 s
estimated error:      0 s
status:               0001  pll
pll time constant:    4
precision:            1e-06 s
frequency tolerance:  500 ppm
jk@quad12:~$ w
  07:03:17 up 1 day, 16:59,  1 user,  load average: 0.00, 0.00, 0.00


