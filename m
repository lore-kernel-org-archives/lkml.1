Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbZCCUkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbZCCUkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:40:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZCCUjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:39:54 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:57750 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbZCCUjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:39:53 -0500
Message-ID: <49AD9598.3030308@krogh.cc>
Date: Tue, 03 Mar 2009 21:39:52 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>	 <49A6F39F.9040801@krogh.cc>	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>	 <49A6FEE2.90700@krogh.cc>	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>	 <49A70B24.6090706@krogh.cc>	 <1235685269.6811.11.camel@localhost.localdomain>	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>	 <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>	 <1235766936.7402.5.camel@localhost.localdomain> <49ABACA0.3090300@krogh.cc>	 <1236029277.7756.0.camel@localhost.localdomain> <49ACC853.8070205@krogh.cc> <1236110026.6068.18.camel@localhost>
In-Reply-To: <1236110026.6068.18.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> Do you see the same behavior if you drop all but one server (including
> the local clock: 127.127.1.0)? 

Yes.
Mar  3 21:20:59 quad12 ntpd[2435]: ntpd 4.2.4p4@1.1520-o Tue Jan  6 
15:50:55 UTC 2009 (1)
Mar  3 21:20:59 quad12 ntpd[2436]: precision = 1.000 usec
Mar  3 21:20:59 quad12 ntpd[2436]: Listening on interface #0 wildcard, 
0.0.0.0#123 Disabled
Mar  3 21:20:59 quad12 ntpd[2436]: Listening on interface #1 wildcard, 
::#123 Disabled
Mar  3 21:20:59 quad12 ntpd[2436]: Listening on interface #2 lo, ::1#123 
Enabled
Mar  3 21:20:59 quad12 ntpd[2436]: Listening on interface #3 bond0, 
fe80::21e:68ff:fe57:8169#123 Enabled
Mar  3 21:20:59 quad12 ntpd[2436]: Listening on interface #4 lo, 
127.0.0.1#123 Enabled
Mar  3 21:20:59 quad12 ntpd[2436]: Listening on interface #5 bond0, 
10.194.132.91#123 Enabled
Mar  3 21:20:59 quad12 ntpd[2436]: kernel time sync status 0040
Mar  3 21:20:59 quad12 ntpd[2436]: frequency initialized -29.286 PPM 
from /var/lib/ntp/ntp.drift
Mar  3 21:21:58 quad12 ntpd[2436]: synchronized to 10.194.133.12, stratum 4
Mar  3 21:21:58 quad12 ntpd[2436]: time reset -6.148275 s
Mar  3 21:21:58 quad12 ntpd[2436]: kernel time sync status change 0001
Mar  3 21:25:01 quad12 ntpd[2436]: synchronized to 10.194.133.12, stratum 4
Mar  3 21:37:03 quad12 ntpd[2436]: time reset -0.664351 s

Only one server and the minpoll 4 maxpoll 4 options to the server line.

-- 
Jesper
