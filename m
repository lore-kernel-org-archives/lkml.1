Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZCUJMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZCUJMR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 05:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZCUJMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 05:12:00 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:54509 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbZCUJL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 05:11:59 -0400
Message-ID: <49C4AF5D.50107@krogh.cc>
Date: Sat, 21 Mar 2009 10:11:57 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>  <49A70B24.6090706@krogh.cc>  <1235685269.6811.11.camel@localhost.localdomain>  <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>  <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>  <1235766936.7402.5.camel@localhost.localdomain> <49AE9EA4.2080500@krogh.cc>  <49AECA3B.5030503@krogh.cc>  <1236193075.3793.63.camel@jstultz-laptop>  <1236220759.6863.7.camel@localhost.localdomain> <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc> <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain> <49BD225C.4070305@krogh.cc> <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain> <49BD4B2D.7000501@krogh.cc> <alpine.LFD.2.00.0903151146550.3131@localhost.localdomain> <49BD5C7C.2060605@krogh.cc> <49BEA1AD.1090901@krogh.cc> <alpine.LFD.2.00.0903161225210.3675@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903161225210.3675@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 16 Mar 2009, Jesper Krogh wrote:
>> you were right. It works. No resets so far.
> 
> Goodie.
> 
> Here's a slightly cleaned-up patch that removes the debug messages, and 
> also re-organizes the code a bit so that it actually uses the "better than 
> 500 ppm" as the way to decide when to stop calibrating.

Can we ship:
commit a6a80e1d8cf82b46a69f88e659da02749231eb36
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Mar 17 07:58:26 2009 -0700

     Fix potential fast PIT TSC calibration startup glitch

and
commit 9e8912e04e612b43897b4b722205408b92f423e5
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Mar 17 08:13:17 2009 -0700

     Fast TSC calibration: calculate proper frequency error bounds


to the 2.6.28-stable series..  The first one needed to apply the second.

Jesper
-- 
Jesper
