Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbYHVMip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbYHVMip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbYHVMie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:38:34 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:39411 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbYHVMid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:38:33 -0400
Message-ID: <48AEB347.2000200@dgreaves.com>
Date: Fri, 22 Aug 2008 13:38:31 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
       Dave Chinner <david@fromorbit.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression? 2.6.27-rc3 segfault on cold boot; not on warm boot.
References: <48AD3921.5090709@dgreaves.com> <200808212026.17590.rjw@sisk.pl>
In-Reply-To: <200808212026.17590.rjw@sisk.pl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> [Adding CCs]
> 
> [The issue is probably present in 2.6.26 too]
> 
> On Thursday, 21 of August 2008, David Greaves wrote:
>> I have a desktop system that has started having problems booting up in the morning.
>>
>> It appears to just happen on more recent kernels.
>> I was having unrelated CDROM problems with a driver in an old kernel and decided
>> to test 2.6.27-rcX
>> The CDROM problem is fine now.
>>
>> However I started having problems on -rc1. I found that the machine was hanging
>> soon after booting and needed a reboot. After a reboot it would work fine for
>> the rest of the day.
>> When -rc3 came out I tried that and the problem still appears to be there.
>>
>> The normal process is now to boot to single-user, ctrl-alt-sysreq-SUB and then
>> reboot to multi-user. This isn't ideal.
>>
>>
>> If I cold boot 2.6.25.3 the problem doesn't occur.
>> I will try different versions over the next few days.

As promised, I tried 2.6.26.3 this morning and didn't have the problem. I will
try again a few times to confirm.
Nb Although the log had an XFS failure, I think the real issue is the segfaults;
I think XFS is a casuality, not a cause. Th problem almost always results in an
XFS crash at some point - but usually preceded by many segfaults in random binaries.

David

