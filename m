Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbYB1DKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbYB1DKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 22:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYB1DKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 22:10:04 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:40152 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYB1DKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 22:10:03 -0500
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Roland Dreier <rdreier@cisco.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 28 Feb 2008 03:09:03 +0000
Subject: RE: hpwdt oops in clflush_cache_range
Thread-Topic: hpwdt oops in clflush_cache_range
Thread-Index: Ach5nqwVouG/vmJgS3qFwAPu9ZT4ygAGIXCg
Message-ID: <E14D1C2A44812C4F9C3ED321127EDF6505829D5A91@G3W0854.americas.hpqcorp.net>
References: <adad4qiwcmz.fsf@cisco.com>
	<alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de>
	<ada1w6y1bzk.fsf@cisco.com>
	<alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de>
	<20080227203655.GA30054@elte.hu>
	<alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de>
	<alpine.LFD.1.00.0802272155190.7583@apollo.tec.linutronix.de>
	<ada3areyu7x.fsf@cisco.com>
	<E14D1C2A44812C4F9C3ED321127EDF6505829D59DF@G3W0854.americas.hpqcorp.net>
 <adamypmx7k1.fsf@cisco.com>
In-Reply-To: <adamypmx7k1.fsf@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Understood. I am just trying to get as much data about the issue as I can.


-----Original Message-----
From: Roland Dreier [mailto:rdreier@cisco.com]
Sent: Wednesday, February 27, 2008 6:13 PM
To: Mingarelli, Thomas
Cc: Thomas Gleixner; Ingo Molnar; linux-kernel@vger.kernel.org
Subject: Re: hpwdt oops in clflush_cache_range

 > Did I read correctly that this was on a Debian OS? Looks like I need to jump in and see what is different about Debian because I haven't seen such an issue on RedHat 5.
 >
 > Yes, the driver was made specifically for G5 (and newer) systems. I will set a system up here and figure out what's wrong as soon as I am sure it is Debian.

I can't imagine that the fact that it's Debian has anything to do with
it -- this is purely in the kernel.

 - R.
