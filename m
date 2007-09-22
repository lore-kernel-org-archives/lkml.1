Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbXIVHGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbXIVHGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 03:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbXIVHGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 03:06:13 -0400
Received: from smtpoutm.mac.com ([17.148.16.71]:61486 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757485AbXIVHGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 03:06:12 -0400
In-Reply-To: <Pine.LNX.4.58.0709211550330.29857@gandalf.stny.rr.com>
References: <1190313251.4518.14.camel@localhost.localdomain> <20070921171256.GA9059@linux.vnet.ibm.com> <Pine.LNX.4.58.0709211550330.29857@gandalf.stny.rr.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B4DA08E1-19C1-4D46-B480-0B880F1443C9@mac.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [RFC PATCH] Add CRC checksum for RCU lists
Date: Sat, 22 Sep 2007 03:04:47 -0400
To: Steven Rostedt <rostedt@goodmis.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 21, 2007, at 17:32:08, Steven Rostedt wrote:
> On Fri, 21 Sep 2007, Paul E. McKenney wrote:
>> On Thu, Sep 20, 2007 at 02:34:11PM -0400, Steven Rostedt wrote:
>>> -#define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
>>> +#ifdef CONFIG_RCU_CRC_HEADER_CHECK
>>> +
>>> +#define RCU_CRC_MAGIC 0xC4809168UL
>>
>> Very magic indeed -- Google doesn't find it, other than in your  
>> patch.  ;-)
>
> Paul, I'm disappointed in you. That number doesn't ring a bell at  
> all??
>
> (hint, ignore the 'C' that was added by me).

LOL!  The RCU patent number; very clever indeed!

Cheers,
Kyle Moffett

