Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYCTMxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYCTMxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 08:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYCTMxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 08:53:06 -0400
Received: from sacred.ru ([62.205.161.221]:52077 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbYCTMxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 08:53:05 -0400
Message-ID: <47E25DF5.3090107@openvz.org>
Date: Thu, 20 Mar 2008 15:52:05 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Benjamin Thery <ben.thery@gmail.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, tilman@imap.cc, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, pekkas@netcore.fi, yoshfuji@linux-ipv6.org,
       dlezcano@fr.ibm.com, xemul@openvz.org, ebiederm@xmission.com
Subject: Re: [2.6.25-rc5-mm1] regression: cannot run Postfix sendmail command
 as non-root
References: <47D98510.60801@imap.cc> <20080319.154947.78332548.davem@davemloft.net> <939d53060803200126k563b9ae7l7197dea4e96ba1ed@mail.gmail.com> <200803201121.07633.rjw@sisk.pl>
In-Reply-To: <200803201121.07633.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 20 Mar 2008 15:52:07 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday, 20 of March 2008, Benjamin Thery wrote:
>> On Wed, Mar 19, 2008 at 11:49 PM, David Miller <davem@davemloft.net> wrote:
>>> From: Andrew Morton <akpm@linux-foundation.org>
>>>  Date: Wed, 19 Mar 2008 14:16:08 -0700
>>>
>>>
>>>  > Although this is advertised as a 2.6.25-rc5-mm1 problem, I assume the
>>>  > regression is also in mainline? 2.6.25-rc6?
>>>
>>>  It is in 2.6.25-rc6, correct.
>>>
>>>  If Pavel or someone else doesn't produce a good fix soon
>>>  I'll revert the guilty change as this bug is worse than
>>>  the problem that changeset fixes.
>> Andre Noll sent a patch to LKML, acked by Pavel:
>>
>> "Fix permissions of /proc/net"
>> http://thread.gmane.org/gmane.linux.kernel/655148
> 
> Have you tested that patch?

I did - works OK, that's why I Acked it.

> Rafael
> 

